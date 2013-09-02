Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab3IBAUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:20:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22059 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3IBAUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:20:21 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-0c-5223d9be117e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/3] extcon: Fix indentation coding style to improve readability
Date: Mon, 02 Sep 2013 09:20:06 +0900
Message-id: <1378081208-20274-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1378081208-20274-1-git-send-email-cw00.choi@samsung.com>
References: <1378081208-20274-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkUHffTeUgg96VMhbXvzxntWhevJ7N
	4mzTG3aLy7vmsFncblzB5sDqsX/uGnaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyniz3rzg
	Z0XF2VUtzA2Mt+O6GDk5JARMJCb+62OCsMUkLtxbz9bFyMUhJLCUUWJrQw8zTNHFqxfYIRLT
	GSUONs1jhnAamSSabzeDVbEJaEnsf3GDDcQWEVCQ2Nz7jBXEZhaoljh36jJYXFggQOL7wU2M
	XYwcHCwCqhK7loiAmLwCrhItd7QhdslJfNjziB3E5hRwk5g66wAjiC0EVDKjfzfYWgmB/2wS
	y951g41nERCQ+Db5EAvIHAkBWYlNB6BulpQ4uOIGywRG4QWMDKsYRVMLkguKk9KLTPWKE3OL
	S/PS9ZLzczcxAkP39L9nE3cw3j9gfYgxGWjcRGYp0eR8YOjnlcQbGpsZWZiamBobmVuakSas
	JM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoEx8jxHhJLl1WcMviX77B+zuafd8rkn
	fjjSOj1Hb+rF+YHFUq+XM3kdyVK3/FR673TKjDihiISAGU+YH17tNbnBNi3qxLuaSgX5g6JC
	6VrNSeu3XxLLkw/jmXQ/6lxH/373e9erbHLuv/8mHmv85ZTm1YQ9KzQXqX76Ej5hX/qH+W+i
	nKzNH1UrsRRnJBpqMRcVJwIAD7HP5HMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jQd19N5WDDHZ0CVpc//Kc1aJ58Xo2
	i7NNb9gtLu+aw2Zxu3EFmwOrx/65a9g9+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2inkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwhjHjzXrzgp8VFWdXtTA3MN6O62Lk5JAQMJG4ePUCO4QtJnHh3nq2
	LkYuDiGB6YwSB5vmMUM4jUwSzbebmUGq2AS0JPa/uMEGYosIKEhs7n3GCmIzC1RLnDt1GSwu
	LBAg8f3gJsYuRg4OFgFViV1LREBMXgFXiZY72hC75CQ+7HkEtpdTwE1i6qwDjCC2EFDJjP7d
	zBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI6MZ1I7GFc2WBxiFOBgVOLhrVih
	HCTEmlhWXJl7iFGCg1lJhJehSSlIiDclsbIqtSg/vqg0J7X4EGMy0E0TmaVEk/OBUZtXEm9o
	bGJmZGlkbmhhZGxOmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxbPtx5ohQpYC7O+cbc
	fsoxd8Fd2zVy/pRdmrA7mnNO3R8/O99Uu+n2H2NeN+n83le/x2rj6mC7ze0vrm8I1Nv6fum2
	yI1/L2q49B4/P9Fs8rsnbadcO5TnijE/X2ztYlo16c0Kgee77/90uHFQX23bnxa7F6Idwuqu
	hU8+K95avJzp/x5LeUE5JZbijERDLeai4kQAFnaw39ACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-adc-jack.c       | 20 +++++-----
 drivers/extcon/extcon-class.c          | 26 ++++++-------
 include/linux/extcon.h                 | 67 ++++++++++++++++++----------------
 include/linux/extcon/extcon-adc-jack.h | 42 ++++++++++-----------
 include/linux/extcon/extcon-gpio.h     | 16 ++++----
 5 files changed, 87 insertions(+), 84 deletions(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index 5985807..5d16428 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -27,16 +27,16 @@
 
 /**
  * struct adc_jack_data - internal data for adc_jack device driver
- * @edev        - extcon device.
- * @cable_names - list of supported cables.
- * @num_cables  - size of cable_names.
- * @adc_conditions       - list of adc value conditions.
- * @num_conditions       - size of adc_conditions.
- * @irq         - irq number of attach/detach event (0 if not exist).
- * @handling_delay      - interrupt handler will schedule extcon event
- *                      handling at handling_delay jiffies.
- * @handler     - extcon event handler called by interrupt handler.
- * @chan       - iio channel being queried.
+ * @edev:		extcon device.
+ * @cable_names:	list of supported cables.
+ * @num_cables:		size of cable_names.
+ * @adc_conditions:	list of adc value conditions.
+ * @num_conditions:	size of adc_conditions.
+ * @irq:		irq number of attach/detach event (0 if not exist).
+ * @handling_delay:	interrupt handler will schedule extcon event
+ *			handling at handling_delay jiffies.
+ * @handler:		extcon event handler called by interrupt handler.
+ * @chan:		iio channel being queried.
  */
 struct adc_jack_data {
 	struct extcon_dev edev;
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 7b6b996..ed456b3 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -74,7 +74,7 @@ static DEFINE_MUTEX(extcon_dev_list_lock);
 
 /**
  * check_mutually_exclusive - Check if new_state violates mutually_exclusive
- *			    condition.
+ *			      condition.
  * @edev:	the extcon device
  * @new_state:	new cable attach status for @edev
  *
@@ -186,7 +186,7 @@ static ssize_t cable_state_show(struct device *dev,
 
 /**
  * extcon_update_state() - Update the cable attach states of the extcon device
- *			only for the masked bits.
+ *			   only for the masked bits.
  * @edev:	the extcon device
  * @mask:	the bit mask to designate updated bits.
  * @state:	new cable attach status for @edev
@@ -224,7 +224,6 @@ int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 		edev->state |= state & mask;
 
 		raw_notifier_call_chain(&edev->nh, old_state, edev);
-
 		/* This could be in interrupt handler */
 		prop_buf = (char *)get_zeroed_page(GFP_ATOMIC);
 		if (prop_buf) {
@@ -337,8 +336,9 @@ EXPORT_SYMBOL_GPL(extcon_get_cable_state);
 
 /**
  * extcon_set_cable_state_() - Set the status of a specific cable.
- * @edev:	the extcon device that has the cable.
- * @index:	cable index that can be retrieved by extcon_find_cable_index().
+ * @edev:		the extcon device that has the cable.
+ * @index:		cable index that can be retrieved by
+ *			extcon_find_cable_index().
  * @cable_state:	the new cable status. The default semantics is
  *			true: attached / false: detached.
  */
@@ -357,8 +357,8 @@ EXPORT_SYMBOL_GPL(extcon_set_cable_state_);
 
 /**
  * extcon_set_cable_state() - Set the status of a specific cable.
- * @edev:	the extcon device that has the cable.
- * @cable_name:	cable name.
+ * @edev:		the extcon device that has the cable.
+ * @cable_name:		cable name.
  * @cable_state:	the new cable status. The default semantics is
  *			true: attached / false: detached.
  *
@@ -417,14 +417,14 @@ static int _call_per_cable(struct notifier_block *nb, unsigned long val,
 
 /**
  * extcon_register_interest() - Register a notifier for a state change of a
- *			      specific cable, not an entier set of cables of a
- *			      extcon device.
- * @obj:	an empty extcon_specific_cable_nb object to be returned.
+ *				specific cable, not an entier set of cables of a
+ *				extcon device.
+ * @obj:		an empty extcon_specific_cable_nb object to be returned.
  * @extcon_name:	the name of extcon device.
  *			if NULL, extcon_register_interest will register
  *			every cable with the target cable_name given.
  * @cable_name:		the target cable name.
- * @nb:		the notifier block to get notified.
+ * @nb:			the notifier block to get notified.
  *
  * Provide an empty extcon_specific_cable_nb. extcon_register_interest() sets
  * the struct for you.
@@ -487,7 +487,7 @@ EXPORT_SYMBOL_GPL(extcon_register_interest);
 
 /**
  * extcon_unregister_interest() - Unregister the notifier registered by
- *				extcon_register_interest().
+ *				  extcon_register_interest().
  * @obj:	the extcon_specific_cable_nb object returned by
  *		extcon_register_interest().
  */
@@ -502,7 +502,7 @@ EXPORT_SYMBOL_GPL(extcon_unregister_interest);
 
 /**
  * extcon_register_notifier() - Register a notifiee to get notified by
- *			      any attach status changes from the extcon.
+ *				any attach status changes from the extcon.
  * @edev:	the extcon device.
  * @nb:		a notifier block to be registered.
  *
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index fcb51c8..c2b652dd 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -51,10 +51,10 @@
 enum extcon_cable_name {
 	EXTCON_USB = 0,
 	EXTCON_USB_HOST,
-	EXTCON_TA, /* Travel Adaptor */
+	EXTCON_TA,			/* Travel Adaptor */
 	EXTCON_FAST_CHARGER,
 	EXTCON_SLOW_CHARGER,
-	EXTCON_CHARGE_DOWNSTREAM, /* Charging an external device */
+	EXTCON_CHARGE_DOWNSTREAM,	/* Charging an external device */
 	EXTCON_HDMI,
 	EXTCON_MHL,
 	EXTCON_DVI,
@@ -76,8 +76,8 @@ struct extcon_cable;
 
 /**
  * struct extcon_dev - An extcon device represents one external connector.
- * @name:	The name of this extcon device. Parent device name is used
- *		if NULL.
+ * @name:		The name of this extcon device. Parent device name is
+ *			used if NULL.
  * @supported_cable:	Array of supported cable names ending with NULL.
  *			If supported_cable is NULL, cable name related APIs
  *			are disabled.
@@ -89,21 +89,21 @@ struct extcon_cable;
  *			be attached simulataneously. {0x7, 0} is equivalent to
  *			{0x3, 0x6, 0x5, 0}. If it is {0xFFFFFFFF, 0}, there
  *			can be no simultaneous connections.
- * @print_name:	An optional callback to override the method to print the
- *		name of the extcon device.
+ * @print_name:		An optional callback to override the method to print the
+ *			name of the extcon device.
  * @print_state:	An optional callback to override the method to print the
- *		status of the extcon device.
- * @dev:	Device of this extcon. Do not provide at register-time.
- * @state:	Attach/detach state of this extcon. Do not provide at
- *		register-time
- * @nh:	Notifier for the state change events from this extcon
- * @entry:	To support list of extcon devices so that users can search
- *		for extcon devices based on the extcon name.
+ *			status of the extcon device.
+ * @dev:		Device of this extcon. Do not provide at register-time.
+ * @state:		Attach/detach state of this extcon. Do not provide at
+ *			register-time.
+ * @nh:			Notifier for the state change events from this extcon
+ * @entry:		To support list of extcon devices so that users can search
+ *			for extcon devices based on the extcon name.
  * @lock:
  * @max_supported:	Internal value to store the number of cables.
  * @extcon_dev_type:	Device_type struct to provide attribute_groups
  *			customized for each extcon device.
- * @cables:	Sysfs subdirectories. Each represents one cable.
+ * @cables:		Sysfs subdirectories. Each represents one cable.
  *
  * In most cases, users only need to provide "User initializing data" of
  * this struct when registering an extcon. In some exceptional cases,
@@ -111,26 +111,27 @@ struct extcon_cable;
  * are overwritten by register function.
  */
 struct extcon_dev {
-	/* --- Optional user initializing data --- */
-	const char	*name;
+	/* Optional user initializing data */
+	const char *name;
 	const char **supported_cable;
-	const u32	*mutually_exclusive;
+	const u32 *mutually_exclusive;
 
-	/* --- Optional callbacks to override class functions --- */
+	/* Optional callbacks to override class functions */
 	ssize_t	(*print_name)(struct extcon_dev *edev, char *buf);
 	ssize_t	(*print_state)(struct extcon_dev *edev, char *buf);
 
-	/* --- Internal data. Please do not set. --- */
-	struct device	*dev;
-	u32		state;
+	/* Internal data. Please do not set. */
+	struct device *dev;
 	struct raw_notifier_head nh;
 	struct list_head entry;
-	spinlock_t lock; /* could be called by irq handler */
 	int max_supported;
+	spinlock_t lock;	/* could be called by irq handler */
+	u32 state;
 
 	/* /sys/class/extcon/.../cable.n/... */
 	struct device_type extcon_dev_type;
 	struct extcon_cable *cables;
+
 	/* /sys/class/extcon/.../mutually_exclusive/... */
 	struct attribute_group attr_g_muex;
 	struct attribute **attrs_muex;
@@ -138,13 +139,13 @@ struct extcon_dev {
 };
 
 /**
- * struct extcon_cable	- An internal data for each cable of extcon device.
- * @edev:	The extcon device
+ * struct extcon_cable - An internal data for each cable of extcon device.
+ * @edev:		The extcon device
  * @cable_index:	Index of this cable in the edev
- * @attr_g:	Attribute group for the cable
- * @attr_name:	"name" sysfs entry
- * @attr_state:	"state" sysfs entry
- * @attrs:	Array pointing to attr_name and attr_state for attr_g
+ * @attr_g:		Attribute group for the cable
+ * @attr_name:		"name" sysfs entry
+ * @attr_state:		"state" sysfs entry
+ * @attrs:		Array pointing to attr_name and attr_state for attr_g
  */
 struct extcon_cable {
 	struct extcon_dev *edev;
@@ -159,11 +160,13 @@ struct extcon_cable {
 
 /**
  * struct extcon_specific_cable_nb - An internal data for
- *				extcon_register_interest().
- * @internal_nb:	a notifier block bridging extcon notifier and cable notifier.
- * @user_nb:	user provided notifier block for events from a specific cable.
+ *				     extcon_register_interest().
+ * @internal_nb:	A notifier block bridging extcon notifier
+ *			and cable notifier.
+ * @user_nb:		user provided notifier block for events from
+ *			a specific cable.
  * @cable_index:	the target cable.
- * @edev:	the target extcon device.
+ * @edev:		the target extcon device.
  * @previous_value:	the saved previous event value.
  */
 struct extcon_specific_cable_nb {
diff --git a/include/linux/extcon/extcon-adc-jack.h b/include/linux/extcon/extcon-adc-jack.h
index 20e9eef..9ca958c 100644
--- a/include/linux/extcon/extcon-adc-jack.h
+++ b/include/linux/extcon/extcon-adc-jack.h
@@ -20,10 +20,10 @@
 
 /**
  * struct adc_jack_cond - condition to use an extcon state
- * @state      - the corresponding extcon state (if 0, this struct denotes
- *             the last adc_jack_cond element among the array)
- * @min_adc    - min adc value for this condition
- * @max_adc    - max adc value for this condition
+ * @state:		the corresponding extcon state (if 0, this struct
+ *			denotes the last adc_jack_cond element among the array)
+ * @min_adc:		min adc value for this condition
+ * @max_adc:		max adc value for this condition
  *
  * For example, if { .state = 0x3, .min_adc = 100, .max_adc = 200}, it means
  * that if ADC value is between (inclusive) 100 and 200, than the cable 0 and
@@ -33,34 +33,34 @@
  * because when no adc_jack_cond is met, state = 0 is automatically chosen.
  */
 struct adc_jack_cond {
-	u32 state; /* extcon state value. 0 if invalid */
+	u32 state;	/* extcon state value. 0 if invalid */
 	u32 min_adc;
 	u32 max_adc;
 };
 
 /**
  * struct adc_jack_pdata - platform data for adc jack device.
- * @name       - name of the extcon device. If null, "adc-jack" is used.
- * @consumer_channel - Unique name to identify the channel on the consumer
- *                   side. This typically describes the channels used within
- *                   the consumer. E.g. 'battery_voltage'
- * @cable_names        - array of cable names ending with null.
- * @adc_contitions     - array of struct adc_jack_cond conditions ending
- *                     with .state = 0 entry. This describes how to decode
- *                     adc values into extcon state.
- * @irq_flags  - irq flags used for the @irq
- * @handling_delay_ms  - in some devices, we need to read ADC value some
- *                     milli-seconds after the interrupt occurs. You may
- *                     describe such delays with @handling_delay_ms, which
- *                     is rounded-off by jiffies.
+ * @name:		name of the extcon device. If null, "adc-jack" is used.
+ * @consumer_channel:	Unique name to identify the channel on the consumer
+ *			side. This typically describes the channels used within
+ *			the consumer. E.g. 'battery_voltage'
+ * @cable_names:	array of cable names ending with null.
+ * @adc_contitions:	array of struct adc_jack_cond conditions ending
+ *			with .state = 0 entry. This describes how to decode
+ *			adc values into extcon state.
+ * @irq_flags:		irq flags used for the @irq
+ * @handling_delay_ms:	in some devices, we need to read ADC value some
+ *			milli-seconds after the interrupt occurs. You may
+ *			describe such delays with @handling_delay_ms, which
+ *			is rounded-off by jiffies.
  */
 struct adc_jack_pdata {
 	const char *name;
 	const char *consumer_channel;
-	/*
-	 * The last entry should be NULL
-	 */
+
+	/* The last entry should be NULL */
 	const char **cable_names;
+
 	/* The last entry's state should be 0 */
 	struct adc_jack_cond *adc_conditions;
 
diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
index 2d8307f..4ce1aa7 100644
--- a/include/linux/extcon/extcon-gpio.h
+++ b/include/linux/extcon/extcon-gpio.h
@@ -25,14 +25,14 @@
 
 /**
  * struct gpio_extcon_platform_data - A simple GPIO-controlled extcon device.
- * @name	The name of this GPIO extcon device.
- * @gpio	Corresponding GPIO.
- * @debounce	Debounce time for GPIO IRQ in ms.
- * @irq_flags	IRQ Flags (e.g., IRQF_TRIGGER_LOW).
- * @state_on	print_state is overriden with state_on if attached. If Null,
- *		default method of extcon class is used.
- * @state_off	print_state is overriden with state_on if detached. If Null,
- *		default method of extcon class is used.
+ * @name:		The name of this GPIO extcon device.
+ * @gpio:		Corresponding GPIO.
+ * @debounce:		Debounce time for GPIO IRQ in ms.
+ * @irq_flags:		IRQ Flags (e.g., IRQF_TRIGGER_LOW).
+ * @state_on:		print_state is overriden with state_on if attached.
+ *			If NULL, default method of extcon class is used.
+ * @state_off:		print_state is overriden with state_on if detached.
+ *			If NUll, default method of extcon class is used.
  *
  * Note that in order for state_on or state_off to be valid, both state_on
  * and state_off should be not NULL. If at least one of them is NULL,
-- 
1.8.0

