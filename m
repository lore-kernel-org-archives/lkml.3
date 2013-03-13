Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab3CMC5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 22:57:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13104 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3CMC5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 22:57:32 -0400
X-AuditID: cbfee690-b7f656d0000007e3-84-513feb18c60f
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: devicetree-discuss@lists.ozlabs.org, khali@linux-fr.org,
        linux@roeck-us.net, dianders@chromium.org, naveenkrishna.ch@gmail.com
Subject: [PATCH v3] hwmon: ntc: Add DT with IIO support to NTC thermistor driver
Date: Wed, 13 Mar 2013 08:25:09 +0530
Message-id: <1363143309-6835-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1363077566-6254-1-git-send-email-ch.naveen@samsung.com>
References: <1363077566-6254-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkSlfitX2gQXO7kMWB2Q9ZLc4uO8hm
	0fg30uLyrjlsFk8WnmGyuDNtL5vFom3/mR3YPWY3XGTx2DnrLrvHlYaTbB7nZyxk9HgwcTeb
	x87vDewenzfJBbBHcdmkpOZklqUW6dslcGWsv7OUuWBraEXX91bWBsYzbl2MnBwSAiYSS/cc
	Y4OwxSQu3FsPZgsJLGWUmPkrAq7myQOgOBdQfDqjxO5DfxghnB4miQUzNrCDVLEJmEkcXLQa
	zBYRsJa4vOc1I4jNLNDCKNGzvRzEFhYIkHj1oYEJxGYRUJV4+mEmM4jNK+Ai8eXBTKA4B9A2
	BYk5k2xAwpwCrhJzZr1mhTjIRWLJqlNgR0gIrGOXuHSqG2qOgMS3yYdYIHplJTYdYIY4WlLi
	4IobLBMYhRcwMqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECAz70/+eTdjBeO+A9SHGZKBx
	E5mlRJPzgXGTVxJvaGxmZGFqYmpsZG5pRpqwkjiveot1oJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQZGzde737/z2zLv4J5Qz/5SofSeS5/ZNszh296vEPa55KeBoN/8+Eb2s5/UkwWmL3Tf
	qa7c/+r5vpoTF24uZcq3m2v37nYcx6l9wfa+pRppQU7vs860Xip6r121emP2dcE9+Ty8zEap
	7m9CV70v+hJ4zP++Tq+I7CmegtzdG+d/adFK91q2xNtFiaU4I9FQi7moOBEAAQ4qUpECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQV2J1/aBBlcesVkcmP2Q1eLssoNs
	Fo1/Iy0u75rDZvFk4RkmizvT9rJZLNr2n9mB3WN2w0UWj52z7rJ7XGk4yeZxfsZCRo8HE3ez
	eez83sDu8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjPV3ljIX
	bA2t6PreytrAeMati5GTQ0LARGLpkwdsELaYxIV764FsLg4hgemMErsP/WGEcHqYJBbM2MAO
	UsUmYCZxcNFqMFtEwFri8p7XjCA2s0ALo0TP9nIQW1ggQOLVhwYmEJtFQFXi6YeZzCA2r4CL
	xJcHM4HiHEDbFCTmTLIBCXMKuErMmfWaFcQWAipZsuoU2wRG3gWMDKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxguPqmdQOxpUNFocYBTgYlXh4Ax7ZBwqxJpYVV+YeYpTgYFYS4W27BBTi
	TUmsrEotyo8vKs1JLT7EmAx01ERmKdHkfGDM55XEGxqbmJsam1qaWJiYWZImrCTOe6DVOlBI
	ID2xJDU7NbUgtQhmCxMHp1QDI7vt4u9yH3WPqkR93h1VlbTEacd1ppytHsphZTfSvsYsjEi/
	9E7LpG39kRcvr4o9Pb23vPShl3rQjH55+/Md0foPyjeZyTzJFltjpnFv8cUTuk8aLn+cKmD2
	VO1otdPUzDVbD1f9KUk5LXd3j8K8u/LihgUXd9x48cTo45n96TLtPnu3h3zbeUWJpTgj0VCL
	uag4EQCeDefV7wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT support to NTC driver to parse the
platform data.

Also adds the support to work as an iio device.

During the probe ntc driver gets the respective channels of ADC
and uses iio_raw_read calls to get the ADC converted value.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v2:
1. Modified Kconfig to select IIO only if OF is defined
2. changed "pullup-uV" to "pullup-uv" in dt bindings
3. allocate pdata in ntc_thermistor_parse_dt and modify the return
   value to platform data pointer, handled other errors for dt bindings.
4. used strlcpy instead of strncpy as the former handles
   null termination
5. made a wrapper function for iio_channel release and defined to
   null in case of non-DT
6. removed a typecase of (s64) which is not needed.

Guenter Roeck, Thanks for your valuble time and comments. They really
are helping me learn and do better on my future patches.

Doug, Thanks for your support and testing these patches.

 .../devicetree/bindings/hwmon/ntc_thermistor.txt   |   29 ++++
 drivers/hwmon/Kconfig                              |    1 +
 drivers/hwmon/ntc_thermistor.c                     |  144 +++++++++++++++++---
 include/linux/platform_data/ntc_thermistor.h       |    8 +-
 4 files changed, 162 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt

diff --git a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
new file mode 100644
index 0000000..c6f6667
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
@@ -0,0 +1,29 @@
+NTC Thermistor hwmon sensors
+-------------------------------
+
+Requires node properties:
+- "compatible" value : one of
+	"ntc,ncp15wb473"
+	"ntc,ncp18wb473"
+	"ntc,ncp21wb473"
+	"ntc,ncp03wb473"
+	"ntc,ncp15wl333"
+- "pullup-uv"	Pull up voltage in micro volts
+- "pullup-ohm"	Pull up resistor value in ohms
+- "pulldown-ohm" Pull down resistor value in ohms
+- "connected-positive" Always ON, If not specified.
+		Status change is possible.
+- "io-channels"	Channel node of ADC to be used for
+		conversion.
+
+Read more about iio bindings at
+	Documentation/devicetree/bindings/iio/iio-bindings.txt
+
+Example:
+	ncp15wb473@0 {
+		compatible = "ntc,ncp15wb473";
+		pullup-uv = <1800000>;
+		pullup-ohm = <47000>;
+		pulldown-ohm = <0>;
+		io-channels = <&adc 3>;
+	};
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 89ac1cb..cc47c12 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -879,6 +879,7 @@ config SENSORS_MCP3021
 
 config SENSORS_NTC_THERMISTOR
 	tristate "NTC thermistor support"
+	select IIO if OF
 	help
 	  This driver supports NTC thermistors sensor reading and its
 	  interpretation. The driver can also monitor the temperature and
diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index b5f63f9..ba0f7b0 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -26,9 +26,16 @@
 #include <linux/math64.h>
 #include <linux/platform_device.h>
 #include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <linux/platform_data/ntc_thermistor.h>
 
+#include <linux/iio/iio.h>
+#include <linux/iio/machine.h>
+#include <linux/iio/driver.h>
+#include <linux/iio/consumer.h>
+
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 
@@ -37,6 +44,15 @@ struct ntc_compensation {
 	unsigned int	ohm;
 };
 
+static const struct platform_device_id ntc_thermistor_id[] = {
+	{ "ncp15wb473", TYPE_NCPXXWB473 },
+	{ "ncp18wb473", TYPE_NCPXXWB473 },
+	{ "ncp21wb473", TYPE_NCPXXWB473 },
+	{ "ncp03wb473", TYPE_NCPXXWB473 },
+	{ "ncp15wl333", TYPE_NCPXXWL333 },
+	{ },
+};
+
 /*
  * A compensation table should be sorted by the values of .ohm
  * in descending order.
@@ -125,6 +141,91 @@ struct ntc_data {
 	char name[PLATFORM_NAME_SIZE];
 };
 
+#ifdef CONFIG_OF
+static int ntc_adc_iio_read(struct ntc_thermistor_platform_data *pdata)
+{
+	struct iio_channel *channel = pdata->chan;
+	unsigned int result;
+	int val, ret;
+
+	ret = iio_read_channel_raw(channel, &val);
+	if (ret < 0) {
+		pr_err("read channel() error: %d\n", ret);
+		return ret;
+	}
+
+	/* unit: mV */
+	result = pdata->pullup_uV * val;
+	result >>= 12;
+
+	return result;
+}
+
+static const struct of_device_id ntc_match[] = {
+	{ .compatible = "ntc,ncp15wb473",
+		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
+	{ .compatible = "ntc,ncp18wb473",
+		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
+	{ .compatible = "ntc,ncp21wb473",
+		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
+	{ .compatible = "ntc,ncp03wb473",
+		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
+	{ .compatible = "ntc,ncp15wl333",
+		.data = &ntc_thermistor_id[TYPE_NCPXXWL333] },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ntc_match);
+
+static struct ntc_thermistor_platform_data *
+ntc_thermistor_parse_dt(struct platform_device *pdev)
+{
+	struct iio_channel *chan;
+	struct device_node *np = pdev->dev.of_node;
+	struct ntc_thermistor_platform_data *pdata;
+
+	if (!np)
+		return NULL;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	chan = iio_channel_get(&pdev->dev, NULL);
+	if (IS_ERR(chan))
+		return (struct ntc_thermistor_platform_data *)PTR_ERR(chan);
+
+	if (of_property_read_u32(np, "pullup-uv", &pdata->pullup_uV))
+		return ERR_PTR(-ENODEV);
+	if (of_property_read_u32(np, "pullup-ohm", &pdata->pullup_ohm))
+		return ERR_PTR(-ENODEV);
+	if (of_property_read_u32(np, "pulldown-ohm", &pdata->pulldown_ohm))
+		return ERR_PTR(-ENODEV);
+
+	if (of_find_property(np, "connected-positive", NULL))
+		pdata->connect = NTC_CONNECTED_POSITIVE;
+	else /* status change should be possible if not always on. */
+		pdata->connect = NTC_CONNECTED_GROUND;
+
+	pdata->chan = chan;
+	pdata->read_uV = ntc_adc_iio_read;
+
+	return pdata;
+}
+static void ntc_iio_channel_release(struct ntc_thermistor_platform_data *pdata)
+{
+	iio_channel_release(pdata->chan);
+}
+#else
+static struct ntc_thermistor_platform_data *
+ntc_thermistor_parse_dt(struct platform_device *pdev)
+{
+	return NULL;
+}
+
+static void ntc_iio_channel_release(struct ntc_thermistor_platform_data *pdata)
+{ }
+#endif
+
 static inline u64 div64_u64_safe(u64 dividend, u64 divisor)
 {
 	if (divisor == 0 && dividend == 0)
@@ -259,7 +360,7 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
 		return data->pdata->read_ohm();
 
 	if (data->pdata->read_uV) {
-		read_uV = data->pdata->read_uV();
+		read_uV = data->pdata->read_uV(data->pdata);
 		if (read_uV < 0)
 			return read_uV;
 		return get_ohm_of_thermistor(data, read_uV);
@@ -311,9 +412,18 @@ static const struct attribute_group ntc_attr_group = {
 
 static int ntc_thermistor_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *of_id =
+			of_match_device(of_match_ptr(ntc_match), &pdev->dev);
+	const struct platform_device_id *pdev_id;
+	struct ntc_thermistor_platform_data *pdata;
 	struct ntc_data *data;
-	struct ntc_thermistor_platform_data *pdata = pdev->dev.platform_data;
-	int ret = 0;
+	int ret;
+
+	pdata = ntc_thermistor_parse_dt(pdev);
+	if (IS_ERR(pdata))
+		return PTR_ERR(pdata);
+	if (pdata == NULL)
+		pdata = pdev->dev.platform_data;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
@@ -349,11 +459,13 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
+	pdev_id = of_id ? of_id->data : platform_get_device_id(pdev);
+
 	data->dev = &pdev->dev;
 	data->pdata = pdata;
-	strlcpy(data->name, pdev->id_entry->name, sizeof(data->name));
+	strlcpy(data->name, pdev_id->name, sizeof(data->name));
 
-	switch (pdev->id_entry->driver_data) {
+	switch (pdev_id->driver_data) {
 	case TYPE_NCPXXWB473:
 		data->comp = ncpXXwb473;
 		data->n_comp = ARRAY_SIZE(ncpXXwb473);
@@ -364,8 +476,7 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(&pdev->dev, "Unknown device type: %lu(%s)\n",
-				pdev->id_entry->driver_data,
-				pdev->id_entry->name);
+				pdev_id->driver_data, pdev_id->name);
 		return -EINVAL;
 	}
 
@@ -384,39 +495,34 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
 		goto err_after_sysfs;
 	}
 
-	dev_info(&pdev->dev, "Thermistor %s:%d (type: %s/%lu) successfully probed.\n",
-			pdev->name, pdev->id, pdev->id_entry->name,
-			pdev->id_entry->driver_data);
+	dev_info(&pdev->dev, "Thermistor type: %s successfully probed.\n",
+								pdev->name);
+
 	return 0;
 err_after_sysfs:
 	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
+	ntc_iio_channel_release(pdata);
 	return ret;
 }
 
 static int ntc_thermistor_remove(struct platform_device *pdev)
 {
 	struct ntc_data *data = platform_get_drvdata(pdev);
+	struct ntc_thermistor_platform_data *pdata = data->pdata;
 
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
+	ntc_iio_channel_release(pdata);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
 
-static const struct platform_device_id ntc_thermistor_id[] = {
-	{ "ncp15wb473", TYPE_NCPXXWB473 },
-	{ "ncp18wb473", TYPE_NCPXXWB473 },
-	{ "ncp21wb473", TYPE_NCPXXWB473 },
-	{ "ncp03wb473", TYPE_NCPXXWB473 },
-	{ "ncp15wl333", TYPE_NCPXXWL333 },
-	{ },
-};
-
 static struct platform_driver ntc_thermistor_driver = {
 	.driver = {
 		.name = "ntc-thermistor",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(ntc_match),
 	},
 	.probe = ntc_thermistor_probe,
 	.remove = ntc_thermistor_remove,
diff --git a/include/linux/platform_data/ntc_thermistor.h b/include/linux/platform_data/ntc_thermistor.h
index 88734e8..fa95f9c 100644
--- a/include/linux/platform_data/ntc_thermistor.h
+++ b/include/linux/platform_data/ntc_thermistor.h
@@ -21,6 +21,8 @@
 #ifndef _LINUX_NTC_H
 #define _LINUX_NTC_H
 
+struct iio_channel;
+
 enum ntc_thermistor_type {
 	TYPE_NCPXXWB473,
 	TYPE_NCPXXWL333,
@@ -39,13 +41,17 @@ struct ntc_thermistor_platform_data {
 	 * described at Documentation/hwmon/ntc_thermistor
 	 *
 	 * pullup/down_ohm: 0 for infinite / not-connected
+	 *
+	 * chan: iio_channel pointer to communicate with the ADC which the
+	 * thermistor is using for conversion of the analog values.
 	 */
-	int (*read_uV)(void);
+	int (*read_uV)(struct ntc_thermistor_platform_data *);
 	unsigned int pullup_uV;
 
 	unsigned int pullup_ohm;
 	unsigned int pulldown_ohm;
 	enum { NTC_CONNECTED_POSITIVE, NTC_CONNECTED_GROUND } connect;
+	struct iio_channel *chan;
 
 	int (*read_ohm)(void);
 };
-- 
1.7.9.5

