import 'package:flutter/material.dart';
import 'repo.dart';

/// Lightweight in-app localization. Recipe data remains unchanged; app UI labels
/// adapt to the language selected on the Language screen.
class L10n {
  static const _data = <String, Map<String, String>>{
    'English': {
      'choose_language': 'Choose Language', 'continue': 'Continue', 'search_dish': 'Search for a dish',
      'explore_cuisines': 'Explore more cuisines', 'cook_with': 'Cook with my ingredients', 'shopping': 'Shopping',
      'favourites': 'My favourite recipes', 'suggestions': 'SUGGESTIONS', 'see_all': 'See All',
      'home': 'Home', 'shop': 'Shop', 'profile': 'My Profile', 'login': 'Login', 'signup': 'Sign up',
      'login_signup': 'Login / Sign up', 'forgot_password': 'Forgot password ?', 'continue_google': 'Continue with google',
      'forgot_title': 'Forgot Password?', 'send_reset': 'Send Reset Link', 'back_login': 'Back to Login',
      'people': 'People', 'method': 'Choose cooking method', 'traditional': 'Traditional Method', 'modern': 'Modern Method',
      'view_instruction': 'View cooking instruction', 'ingredients': 'Ingredients', 'at_home': 'At Home', 'need_buy': 'Need to buy',
      'availability': 'Ingredient Availability check', 'update': 'Update', 'shopping_list': 'Shopping List',
      'qty_buy': 'Qty to buy', 'market_price': 'Market price', 'market_prices': 'Market prices',
      'empty_shopping': 'Your shopping list is empty', 'all_set': 'All Set !', 'start_cooking': 'Start cooking',
      'view_all_steps': 'View all steps', 'previous': 'Previous', 'next': 'Next', 'finish': 'Finish', 'save_recipes': 'Save recipes',
      'saved_recipes': 'Saved Recipes', 'no_saved': 'No saved recipes yet', 'no_fav': 'No favourite recipes yet',
      'diet': 'Dietary Preferences', 'notifications': 'Notifications', 'help': 'Help & Support', 'about': 'About Us',
      'logout': 'Log Out ?', 'yes_logout': 'Yes, Log Out', 'cancel': 'Cancel', 'save': 'Save',
      'preferences_saved': 'Preferences saved', 'select_language': 'select your preferred language to continue,',
      'all_steps': 'All steps', 'step': 'Step', 'steps': 'Steps', 'recipes': 'Recipes', 'no_recipes': 'No recipes found',
      'no_ingredients': 'No ingredient list available', 'no_cooking_steps': 'No cooking steps available',
      'your_ingredients': 'Your Ingredients', 'clear_all': 'clear all', 'or': 'or', 'healthy': 'Healthy food . Happier you', 'hello': 'HELLO !....👋\nwhat would you like to cook today ?...', 'explore_world': 'Explore more recipes around the world.....', 'add_ingredients': 'Add ingredients to see suggestions', 'or_categories': 'Or choose from categories', 'please_choose_method': 'Please choose a method', 'ingredient_note': 'This will adjust the quantities of ingredients\nautomatically.',
    },
    'Tamil': {
      'choose_language': 'மொழியைத் தேர்ந்தெடுக்கவும்', 'continue': 'தொடரவும்', 'search_dish': 'உணவைத் தேடுங்கள்',
      'explore_cuisines': 'மேலும் உணவு வகைகளைப் பார்க்க', 'cook_with': 'என்னிடம் உள்ள பொருட்களுடன் சமைக்க', 'shopping': 'ஷாப்பிங்',
      'favourites': 'எனது பிடித்த சமையல் குறிப்புகள்', 'suggestions': 'பரிந்துரைகள்', 'see_all': 'அனைத்தையும் பார்க்க',
      'home': 'முகப்பு', 'shop': 'ஷாப்பிங்', 'profile': 'என் சுயவிவரம்', 'login': 'உள்நுழைவு', 'signup': 'பதிவு செய்ய',
      'login_signup': 'உள்நுழைவு / பதிவு', 'forgot_password': 'கடவுச்சொல் மறந்துவிட்டதா?', 'continue_google': 'Google மூலம் தொடரவும்',
      'forgot_title': 'கடவுச்சொல் மறந்துவிட்டதா?', 'send_reset': 'மீட்டமைப்பு இணைப்பை அனுப்பவும்', 'back_login': 'உள்நுழைவுக்கு திரும்ப',
      'people': 'நபர்கள்', 'method': 'சமையல் முறையைத் தேர்ந்தெடுக்கவும்', 'traditional': 'பாரம்பரிய முறை', 'modern': 'நவீன முறை',
      'view_instruction': 'சமையல் வழிமுறையைப் பார்க்க', 'ingredients': 'தேவையான பொருட்கள்', 'at_home': 'வீட்டில் உள்ளது', 'need_buy': 'வாங்க வேண்டும்',
      'availability': 'பொருட்கள் இருப்பு சரிபார்ப்பு', 'update': 'புதுப்பிக்கவும்', 'shopping_list': 'ஷாப்பிங் பட்டியல்',
      'qty_buy': 'வாங்க வேண்டிய அளவு', 'market_price': 'சந்தை விலை', 'market_prices': 'சந்தை விலைகள்',
      'empty_shopping': 'உங்கள் ஷாப்பிங் பட்டியல் காலியாக உள்ளது', 'all_set': 'அனைத்தும் தயார்!', 'start_cooking': 'சமைக்கத் தொடங்குங்கள்',
      'view_all_steps': 'அனைத்து படிகளையும் பார்க்க', 'previous': 'முந்தையது', 'next': 'அடுத்தது', 'finish': 'முடிக்கவும்', 'save_recipes': 'சமையல் குறிப்புகளைச் சேமிக்க',
      'saved_recipes': 'சேமித்த சமையல் குறிப்புகள்', 'no_saved': 'சேமித்த சமையல் குறிப்புகள் இல்லை', 'no_fav': 'பிடித்த சமையல் குறிப்புகள் இல்லை',
      'diet': 'உணவு விருப்பங்கள்', 'notifications': 'அறிவிப்புகள்', 'help': 'உதவி & ஆதரவு', 'about': 'எங்களைப் பற்றி',
      'logout': 'வெளியேறவா?', 'yes_logout': 'ஆம், வெளியேறு', 'cancel': 'ரத்து செய்', 'save': 'சேமி',
      'preferences_saved': 'விருப்பங்கள் சேமிக்கப்பட்டன', 'select_language': 'தொடர உங்களுக்கு விருப்பமான மொழியைத் தேர்ந்தெடுக்கவும்',
      'all_steps': 'அனைத்து படிகள்', 'step': 'படி', 'steps': 'படிகள்', 'recipes': 'சமையல் குறிப்புகள்', 'no_recipes': 'சமையல் குறிப்புகள் இல்லை',
      'no_ingredients': 'தேவையான பொருட்கள் பட்டியல் இல்லை', 'no_cooking_steps': 'சமையல் படிகள் இல்லை',
      'your_ingredients': 'உங்களிடம் உள்ள பொருட்கள்', 'clear_all': 'அனைத்தையும் அழிக்க', 'or': 'அல்லது', 'healthy': 'ஆரோக்கியமான உணவு . மகிழ்ச்சியான நீங்கள்', 'hello': 'வணக்கம் !....👋\nஇன்று என்ன சமைக்க விரும்புகிறீர்கள்?', 'explore_world': 'உலகம் முழுவதும் மேலும் சமையல் குறிப்புகளைப் பாருங்கள்.....', 'add_ingredients': 'பரிந்துரைகளைப் பார்க்க பொருட்களைச் சேர்க்கவும்', 'or_categories': 'அல்லது வகைகளில் தேர்வு செய்யவும்', 'please_choose_method': 'ஒரு முறையைத் தேர்ந்தெடுக்கவும்', 'ingredient_note': 'பொருட்களின் அளவு தானாக மாற்றப்படும்.',
    },
    'Hindi': {
      'choose_language': 'भाषा चुनें', 'continue': 'जारी रखें', 'search_dish': 'व्यंजन खोजें', 'explore_cuisines': 'और व्यंजन देखें',
      'cook_with': 'मेरे पास मौजूद सामग्री से पकाएँ', 'shopping': 'खरीदारी', 'favourites': 'मेरी पसंदीदा रेसिपी', 'suggestions': 'सुझाव', 'see_all': 'सभी देखें',
      'home': 'होम', 'shop': 'शॉप', 'profile': 'मेरी प्रोफ़ाइल', 'login': 'लॉगिन', 'signup': 'साइन अप', 'login_signup': 'लॉगिन / साइन अप',
      'forgot_password': 'पासवर्ड भूल गए?', 'continue_google': 'Google से जारी रखें', 'forgot_title': 'पासवर्ड भूल गए?', 'send_reset': 'रीसेट लिंक भेजें', 'back_login': 'लॉगिन पर वापस',
      'people': 'लोग', 'method': 'खाना पकाने की विधि चुनें', 'traditional': 'पारंपरिक विधि', 'modern': 'आधुनिक विधि', 'view_instruction': 'पकाने की विधि देखें',
      'ingredients': 'सामग्री', 'at_home': 'घर पर है', 'need_buy': 'खरीदना है', 'availability': 'सामग्री उपलब्धता जाँच', 'update': 'अपडेट',
      'shopping_list': 'खरीदारी सूची', 'qty_buy': 'खरीदने की मात्रा', 'market_price': 'बाज़ार मूल्य', 'market_prices': 'बाज़ार मूल्य',
      'empty_shopping': 'आपकी खरीदारी सूची खाली है', 'all_set': 'सब तैयार!', 'start_cooking': 'पकाना शुरू करें', 'view_all_steps': 'सभी चरण देखें',
      'previous': 'पिछला', 'next': 'अगला', 'finish': 'समाप्त करें', 'save_recipes': 'रेसिपी सेव करें', 'saved_recipes': 'सेव की गई रेसिपी', 'no_saved': 'कोई सेव की गई रेसिपी नहीं',
      'no_fav': 'कोई पसंदीदा रेसिपी नहीं', 'diet': 'आहार प्राथमिकताएँ', 'notifications': 'सूचनाएँ', 'help': 'मदद और सहायता', 'about': 'हमारे बारे में',
      'logout': 'लॉग आउट करें?', 'yes_logout': 'हाँ, लॉग आउट', 'cancel': 'रद्द करें', 'save': 'सेव करें', 'preferences_saved': 'प्राथमिकताएँ सेव हो गईं',
      'select_language': 'जारी रखने के लिए अपनी पसंदीदा भाषा चुनें', 'all_steps': 'सभी चरण', 'step': 'चरण', 'steps': 'चरण', 'recipes': 'रेसिपी', 'no_recipes': 'कोई रेसिपी नहीं मिली',
      'no_ingredients': 'सामग्री सूची उपलब्ध नहीं', 'no_cooking_steps': 'पकाने के चरण उपलब्ध नहीं', 'your_ingredients': 'आपकी सामग्री', 'clear_all': 'सब साफ करें', 'or': 'या', 'healthy': 'स्वस्थ भोजन . खुशहाल आप', 'hello': 'नमस्ते !....👋\nआज क्या पकाना चाहेंगे?', 'explore_world': 'दुनिया भर की और रेसिपी देखें.....', 'add_ingredients': 'सुझाव देखने के लिए सामग्री जोड़ें', 'or_categories': 'या श्रेणियों में चुनें', 'please_choose_method': 'कृपया एक विधि चुनें', 'ingredient_note': 'सामग्री की मात्रा अपने आप समायोजित होगी.',
    },
    'Telugu': {
      'choose_language': 'భాషను ఎంచుకోండి', 'continue': 'కొనసాగించండి', 'search_dish': 'వంటకం కోసం వెతకండి', 'explore_cuisines': 'మరిన్ని వంటకాలను చూడండి',
      'cook_with': 'నా దగ్గర ఉన్న పదార్థాలతో వండండి', 'shopping': 'షాపింగ్', 'favourites': 'నా ఇష్టమైన వంటకాలు', 'suggestions': 'సూచనలు', 'see_all': 'అన్నీ చూడండి',
      'home': 'హోమ్', 'shop': 'షాప్', 'profile': 'నా ప్రొఫైల్', 'login': 'లాగిన్', 'signup': 'సైన్ అప్', 'login_signup': 'లాగిన్ / సైన్ అప్',
      'forgot_password': 'పాస్‌వర్డ్ మర్చిపోయారా?', 'continue_google': 'Google తో కొనసాగండి', 'forgot_title': 'పాస్‌వర్డ్ మర్చిపోయారా?', 'send_reset': 'రీసెట్ లింక్ పంపండి', 'back_login': 'లాగిన్‌కు తిరిగి',
      'people': 'వ్యక్తులు', 'method': 'వంట విధానాన్ని ఎంచుకోండి', 'traditional': 'సాంప్రదాయ విధానం', 'modern': 'ఆధునిక విధానం', 'view_instruction': 'వంట సూచనలను చూడండి',
      'ingredients': 'పదార్థాలు', 'at_home': 'ఇంట్లో ఉన్నాయి', 'need_buy': 'కొనాలి', 'availability': 'పదార్థాల లభ్యత తనిఖీ', 'update': 'నవీకరించండి',
      'shopping_list': 'షాపింగ్ జాబితా', 'qty_buy': 'కొనాల్సిన పరిమాణం', 'market_price': 'మార్కెట్ ధర', 'market_prices': 'మార్కెట్ ధరలు',
      'empty_shopping': 'మీ షాపింగ్ జాబితా ఖాళీగా ఉంది', 'all_set': 'అన్నీ సిద్ధం!', 'start_cooking': 'వంట ప్రారంభించండి', 'view_all_steps': 'అన్ని దశలను చూడండి',
      'previous': 'మునుపటి', 'next': 'తర్వాత', 'finish': 'ముగించండి', 'save_recipes': 'వంటకాలను సేవ్ చేయండి', 'saved_recipes': 'సేవ్ చేసిన వంటకాలు', 'no_saved': 'సేవ్ చేసిన వంటకాలు లేవు',
      'no_fav': 'ఇష్టమైన వంటకాలు లేవు', 'diet': 'ఆహార ప్రాధాన్యతలు', 'notifications': 'నోటిఫికేషన్లు', 'help': 'సహాయం & మద్దతు', 'about': 'మా గురించి',
      'logout': 'లాగ్ అవుట్ చేయాలా?', 'yes_logout': 'అవును, లాగ్ అవుట్', 'cancel': 'రద్దు', 'save': 'సేవ్', 'preferences_saved': 'ప్రాధాన్యతలు సేవ్ అయ్యాయి',
      'select_language': 'కొనసాగడానికి మీకు ఇష్టమైన భాషను ఎంచుకోండి', 'all_steps': 'అన్ని దశలు', 'step': 'దశ', 'steps': 'దశలు', 'recipes': 'వంటకాలు', 'no_recipes': 'వంటకాలు కనబడలేదు',
      'no_ingredients': 'పదార్థాల జాబితా అందుబాటులో లేదు', 'no_cooking_steps': 'వంట దశలు అందుబాటులో లేవు', 'your_ingredients': 'మీ పదార్థాలు', 'clear_all': 'అన్నీ క్లియర్ చేయండి', 'or': 'లేదా', 'healthy': 'ఆరోగ్యకరమైన ఆహారం . సంతోషకరమైన మీరు', 'hello': 'నమస్కారం !....👋\nఈ రోజు ఏమి వండాలని అనుకుంటున్నారు?', 'explore_world': 'ప్రపంచంలోని మరిన్ని వంటకాలను చూడండి.....', 'add_ingredients': 'సూచనలు చూడటానికి పదార్థాలను జోడించండి', 'or_categories': 'లేదా వర్గాల నుంచి ఎంచుకోండి', 'please_choose_method': 'దయచేసి ఒక విధానాన్ని ఎంచుకోండి', 'ingredient_note': 'పదార్థాల పరిమాణాలు ఆటోమేటిక్‌గా మారుతాయి.',
    },
    'Malayalam': {
      'choose_language': 'ഭാഷ തിരഞ്ഞെടുക്കുക', 'continue': 'തുടരുക', 'search_dish': 'വിഭവം തിരയുക', 'explore_cuisines': 'കൂടുതൽ വിഭവങ്ങൾ കാണുക',
      'cook_with': 'എന്റെ കൈവശമുള്ള ചേരുവകൾ ഉപയോഗിച്ച് പാചകം ചെയ്യുക', 'shopping': 'ഷോപ്പിംഗ്', 'favourites': 'എന്റെ പ്രിയപ്പെട്ട പാചകക്കുറിപ്പുകൾ', 'suggestions': 'നിർദ്ദേശങ്ങൾ', 'see_all': 'എല്ലാം കാണുക',
      'home': 'ഹോം', 'shop': 'ഷോപ്പ്', 'profile': 'എന്റെ പ്രൊഫൈൽ', 'login': 'ലോഗിൻ', 'signup': 'സൈൻ അപ്പ്', 'login_signup': 'ലോഗിൻ / സൈൻ അപ്പ്',
      'forgot_password': 'പാസ്‌വേഡ് മറന്നോ?', 'continue_google': 'Google ഉപയോഗിച്ച് തുടരുക', 'forgot_title': 'പാസ്‌വേഡ് മറന്നോ?', 'send_reset': 'റീസെറ്റ് ലിങ്ക് അയയ്ക്കുക', 'back_login': 'ലോഗിനിലേക്ക് മടങ്ങുക',
      'people': 'ആളുകൾ', 'method': 'പാചകരീതി തിരഞ്ഞെടുക്കുക', 'traditional': 'പരമ്പരാഗത രീതി', 'modern': 'ആധുനിക രീതി', 'view_instruction': 'പാചക നിർദ്ദേശങ്ങൾ കാണുക',
      'ingredients': 'ചേരുവകൾ', 'at_home': 'വീട്ടിലുണ്ട്', 'need_buy': 'വാങ്ങണം', 'availability': 'ചേരുവ ലഭ്യത പരിശോധിക്കുക', 'update': 'അപ്ഡേറ്റ്',
      'shopping_list': 'ഷോപ്പിംഗ് ലിസ്റ്റ്', 'qty_buy': 'വാങ്ങേണ്ട അളവ്', 'market_price': 'വിപണി വില', 'market_prices': 'വിപണി വിലകൾ', 'empty_shopping': 'നിങ്ങളുടെ ഷോപ്പിംഗ് ലിസ്റ്റ് ശൂന്യമാണ്',
      'all_set': 'എല്ലാം തയ്യാറാണ്!', 'start_cooking': 'പാചകം ആരംഭിക്കുക', 'view_all_steps': 'എല്ലാ ഘട്ടങ്ങളും കാണുക', 'previous': 'മുമ്പത്തെ', 'next': 'അടുത്തത്', 'finish': 'പൂർത്തിയാക്കുക',
      'save_recipes': 'പാചകക്കുറിപ്പുകൾ സേവ് ചെയ്യുക', 'saved_recipes': 'സേവ് ചെയ്ത പാചകക്കുറിപ്പുകൾ', 'no_saved': 'സേവ് ചെയ്ത പാചകക്കുറിപ്പുകളില്ല', 'no_fav': 'പ്രിയപ്പെട്ട പാചകക്കുറിപ്പുകളില്ല',
      'diet': 'ഭക്ഷണ മുൻഗണനകൾ', 'notifications': 'അറിയിപ്പുകൾ', 'help': 'സഹായവും പിന്തുണയും', 'about': 'ഞങ്ങളെക്കുറിച്ച്', 'logout': 'ലോഗ് ഔട്ട് ചെയ്യണോ?', 'yes_logout': 'അതെ, ലോഗ് ഔട്ട്',
      'cancel': 'റദ്ദാക്കുക', 'save': 'സേവ്', 'preferences_saved': 'മുൻഗണനകൾ സേവ് ചെയ്തു', 'select_language': 'തുടരാൻ നിങ്ങളുടെ ഇഷ്ടഭാഷ തിരഞ്ഞെടുക്കുക',
      'all_steps': 'എല്ലാ ഘട്ടങ്ങളും', 'step': 'ഘട്ടം', 'steps': 'ഘട്ടങ്ങൾ', 'recipes': 'പാചകക്കുറിപ്പുകൾ', 'no_recipes': 'പാചകക്കുറിപ്പുകളൊന്നും കണ്ടെത്തിയില്ല', 'no_ingredients': 'ചേരുവകളുടെ പട്ടിക ലഭ്യമല്ല',
      'no_cooking_steps': 'പാചക ഘട്ടങ്ങൾ ലഭ്യമല്ല', 'your_ingredients': 'നിങ്ങളുടെ ചേരുവകൾ', 'clear_all': 'എല്ലാം മായ്ക്കുക', 'or': 'അല്ലെങ്കിൽ', 'healthy': 'ആരോഗ്യകരമായ ഭക്ഷണം . സന്തോഷമുള്ള നിങ്ങൾ', 'hello': 'ഹലോ !....👋\nഇന്ന് എന്താണ് പാചകം ചെയ്യാൻ ആഗ്രഹിക്കുന്നത്?', 'explore_world': 'ലോകമെമ്പാടുമുള്ള കൂടുതൽ പാചകക്കുറിപ്പുകൾ കാണുക.....', 'add_ingredients': 'നിർദ്ദേശങ്ങൾ കാണാൻ ചേരുവകൾ ചേർക്കുക', 'or_categories': 'അല്ലെങ്കിൽ വിഭാഗങ്ങളിൽ നിന്ന് തിരഞ്ഞെടുക്കുക', 'please_choose_method': 'ഒരു രീതി തിരഞ്ഞെടുക്കുക', 'ingredient_note': 'ചേരുവകളുടെ അളവ് സ്വയമേവ ക്രമീകരിക്കും.',
    },
    'Kannada': {
      'choose_language': 'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ', 'continue': 'ಮುಂದುವರಿಸಿ', 'search_dish': 'ತಿನಿಸನ್ನು ಹುಡುಕಿ', 'explore_cuisines': 'ಹೆಚ್ಚಿನ ತಿನಿಸುಗಳನ್ನು ನೋಡಿ',
      'cook_with': 'ನನ್ನಲ್ಲಿರುವ ಪದಾರ್ಥಗಳಿಂದ ಅಡುಗೆ ಮಾಡಿ', 'shopping': 'ಶಾಪಿಂಗ್', 'favourites': 'ನನ್ನ ಮೆಚ್ಚಿನ ತಿನಿಸುಗಳು', 'suggestions': 'ಸಲಹೆಗಳು', 'see_all': 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ',
      'home': 'ಮುಖಪುಟ', 'shop': 'ಶಾಪ್', 'profile': 'ನನ್ನ ಪ್ರೊಫೈಲ್', 'login': 'ಲಾಗಿನ್', 'signup': 'ಸೈನ್ ಅಪ್', 'login_signup': 'ಲಾಗಿನ್ / ಸೈನ್ ಅಪ್',
      'forgot_password': 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆತಿರಾ?', 'continue_google': 'Google ಮೂಲಕ ಮುಂದುವರಿಸಿ', 'forgot_title': 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆತಿರಾ?', 'send_reset': 'ರೀಸೆಟ್ ಲಿಂಕ್ ಕಳುಹಿಸಿ', 'back_login': 'ಲಾಗಿನ್‌ಗೆ ಹಿಂತಿರುಗಿ',
      'people': 'ಜನರು', 'method': 'ಅಡುಗೆ ವಿಧಾನ ಆಯ್ಕೆಮಾಡಿ', 'traditional': 'ಸಾಂಪ್ರದಾಯಿಕ ವಿಧಾನ', 'modern': 'ಆಧುನಿಕ ವಿಧಾನ', 'view_instruction': 'ಅಡುಗೆ ಸೂಚನೆಗಳನ್ನು ನೋಡಿ',
      'ingredients': 'ಪದಾರ್ಥಗಳು', 'at_home': 'ಮನೆಯಲ್ಲಿ ಇದೆ', 'need_buy': 'ಖರೀದಿಸಬೇಕು', 'availability': 'ಪದಾರ್ಥ ಲಭ್ಯತೆ ಪರಿಶೀಲನೆ', 'update': 'ನವೀಕರಿಸಿ',
      'shopping_list': 'ಶಾಪಿಂಗ್ ಪಟ್ಟಿ', 'qty_buy': 'ಖರೀದಿಸಬೇಕಾದ ಪ್ರಮಾಣ', 'market_price': 'ಮಾರುಕಟ್ಟೆ ಬೆಲೆ', 'market_prices': 'ಮಾರುಕಟ್ಟೆ ಬೆಲೆಗಳು', 'empty_shopping': 'ನಿಮ್ಮ ಶಾಪಿಂಗ್ ಪಟ್ಟಿ ಖಾಲಿಯಾಗಿದೆ',
      'all_set': 'ಎಲ್ಲವೂ ಸಿದ್ಧ!', 'start_cooking': 'ಅಡುಗೆ ಪ್ರಾರಂಭಿಸಿ', 'view_all_steps': 'ಎಲ್ಲಾ ಹಂತಗಳನ್ನು ನೋಡಿ', 'previous': 'ಹಿಂದಿನ', 'next': 'ಮುಂದಿನ',
      'finish': 'ಮುಗಿಸಿ', 'save_recipes': 'ತಿನಿಸುಗಳನ್ನು ಉಳಿಸಿ', 'saved_recipes': 'ಉಳಿಸಿದ ತಿನಿಸುಗಳು', 'no_saved': 'ಉಳಿಸಿದ ತಿನಿಸುಗಳಿಲ್ಲ', 'no_fav': 'ಮೆಚ್ಚಿನ ತಿನಿಸುಗಳಿಲ್ಲ', 'diet': 'ಆಹಾರ ಆದ್ಯತೆಗಳು',
      'notifications': 'ಅಧಿಸೂಚನೆಗಳು', 'help': 'ಸಹಾಯ ಮತ್ತು ಬೆಂಬಲ', 'about': 'ನಮ್ಮ ಬಗ್ಗೆ', 'logout': 'ಲಾಗ್ ಔಟ್ ಮಾಡಬೇಕೇ?', 'yes_logout': 'ಹೌದು, ಲಾಗ್ ಔಟ್', 'cancel': 'ರದ್ದುಮಾಡಿ', 'save': 'ಉಳಿಸಿ',
      'preferences_saved': 'ಆದ್ಯತೆಗಳನ್ನು ಉಳಿಸಲಾಗಿದೆ', 'select_language': 'ಮುಂದುವರಿಸಲು ನಿಮ್ಮ ಇಷ್ಟದ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ', 'all_steps': 'ಎಲ್ಲಾ ಹಂತಗಳು', 'step': 'ಹಂತ', 'steps': 'ಹಂತಗಳು',
      'recipes': 'ತಿನಿಸುಗಳು', 'no_recipes': 'ಯಾವುದೇ ತಿನಿಸುಗಳು ಕಂಡುಬಂದಿಲ್ಲ', 'no_ingredients': 'ಪದಾರ್ಥಗಳ ಪಟ್ಟಿ ಲಭ್ಯವಿಲ್ಲ', 'no_cooking_steps': 'ಅಡುಗೆ ಹಂತಗಳು ಲಭ್ಯವಿಲ್ಲ', 'your_ingredients': 'ನಿಮ್ಮ ಪದಾರ್ಥಗಳು', 'clear_all': 'ಎಲ್ಲವನ್ನೂ ತೆರವುಗೊಳಿಸಿ', 'or': 'ಅಥವಾ', 'healthy': 'ಆರೋಗ್ಯಕರ ಆಹಾರ . ಸಂತೋಷದ ನೀವು', 'hello': 'ನಮಸ್ಕಾರ !....👋\nಇಂದು ಏನು ಅಡುಗೆ ಮಾಡಲು ಬಯಸುತ್ತೀರಿ?', 'explore_world': 'ಜಗತ್ತಿನ ಇನ್ನಷ್ಟು ತಿನಿಸುಗಳನ್ನು ನೋಡಿ.....', 'add_ingredients': 'ಸಲಹೆಗಳನ್ನು ನೋಡಲು ಪದಾರ್ಥಗಳನ್ನು ಸೇರಿಸಿ', 'or_categories': 'ಅಥವಾ ವರ್ಗಗಳಿಂದ ಆಯ್ಕೆಮಾಡಿ', 'please_choose_method': 'ದಯವಿಟ್ಟು ಒಂದು ವಿಧಾನ ಆಯ್ಕೆಮಾಡಿ', 'ingredient_note': 'ಪದಾರ್ಥಗಳ ಪ್ರಮಾಣವನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಹೊಂದಿಸಲಾಗುತ್ತದೆ.',
    },
  };

  static String t(String key) {
    final lang = Repo.i.language;
    return _data[lang]?[key] ?? _data['English']![key] ?? key;
  }
}

extension L10nContext on BuildContext {
  String tr(String key) => L10n.t(key);
}
