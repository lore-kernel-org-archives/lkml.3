Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3CLIls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 04:41:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12414 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3CLIlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:41:45 -0400
X-AuditID: cbfee690-b7f656d0000007e3-d7-513eea47ed39
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: devicetree-discuss@lists.ozlabs.org, khali@linux-fr.org,
        linux@roeck-us.net, dianders@chromium.org, naveenkrishna.ch@gmail.com
Subject: [PATCH v2] hwmon: ntc: Add DT with IIO support to NTC thermistor driver
Date: Tue, 12 Mar 2013 14:09:26 +0530
Message-id: <1363077566-6254-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkRtf9lV2gwZkOIYsDsx+yWpxddpDN
	ovFvpMXlXXPYLJ4sPMNkcWfaXjaLRdv+Mzuwe8xuuMjisXPWXXaPKw0n2TzOz1jI6PFg4m42
	j53fG9g9Pm+SC2CP4rJJSc3JLEst0rdL4Mq42TmFtaDBp6Lv9BG2BsbPdl2MnBwSAiYS36as
	Y4GwxSQu3FvPBmILCSxllDh/xQSm5sqmJqYuRi6g+HRGic+/fkE5PUwS7xcvZgSpYhMwkzi4
	aDU7iC0iYC1xec9rsDizQAujRM/28i5GDg5hgQCJ201yIGEWAVWJLa/esoGEeQVcJHrva4GY
	EgIKEnMm2YBMlxCYzC4x9exXFohyAYlvkw+xQNTISmw6wAxxmqTEwRU3WCYwCi5gZFjFKJpa
	kFxQnJReZKJXnJhbXJqXrpecn7uJERjCp/89m7CD8d4B60OMyUDjJjJLiSbnA2MgryTe0NjM
	yMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M3dkqC+sF+vaf
	vnpbw134JfeuN0yfjlh2XYjamxneo6zRocG97dXuEEXp2R3TIjuLrcX9nudp+E5PreIOurDP
	oXGTQJ8oc5PUagmuevET6/Lm6BZ8SxN6FsD4OEwg4ZWopMFp17SLZa1HYydelvgU+6HcVHjm
	xbZsZ2OX2RV9Zc+2ewYJySixFGckGmoxFxUnAgBnj0NPdwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jQV33V3aBBq272S0OzH7IanF22UE2
	i8a/kRaXd81hs3iy8AyTxZ1pe9ksFm37z+zA7jG74SKLx85Zd9k9rjScZPM4P2Mho8eDibvZ
	PHZ+b2D3+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxs3OKawF
	DT4VfaePsDUwfrbrYuTkkBAwkbiyqYkJwhaTuHBvPVsXIxeHkMB0RonPv34xQTg9TBLvFy9m
	BKliEzCTOLhoNTuILSJgLXF5z2uwOLNAC6NEz/byLkYODmGBAInbTXIgYRYBVYktr96ygYR5
	BVwkeu9rgZgSAgoScybZTGDkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOEaeSe9g
	XNVgcYhRgINRiYdX4ZttoBBrYllxZe4hRgkOZiUR3ozNdoFCvCmJlVWpRfnxRaU5qcWHGJOB
	dk9klhJNzgfGb15JvKGxibmpsamliYWJmSVpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1
	MEa1rbnY9+nD8uAP4fOtqwJs3Nj2TJw523NfaOZBc0bOyjvns0o3/VSdvVTiw6HTp861vdvS
	U7Wtctq2+We2Vk6z5FzEKb3qxkN//4W1bqfOGe1l7Vz2hkckJ4F3yxXv1Q1L10ZtZ38jen7i
	O82ld+32fnYvOeSX2K+4afczq45jBz+8PJhe0ZesxFKckWioxVxUnAgATn0hY9UCAAA=
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
Changes since v1:
1. Combimed all the IIO and OF/device tree changes under CONFIG_OF
2. parse_dt function now checks for of_node and iio_channels sanity
3. merged both the patches to single, as they cant build independently
4. used pdev_id for proper logging and support of DT and non DT based probing
5. Rebased on linux git tree
6. Added documentation for device tree bindings

Sorry, for posting a patch rebased on local working branch.
Thanks Doug, for pointing out.
 .../devicetree/bindings/hwmon/ntc_thermistor.txt   |   29 +++++
 drivers/hwmon/ntc_thermistor.c                     |  133 +++++++++++++++++---
 include/linux/platform_data/ntc_thermistor.h       |    6 +-
 3 files changed, 148 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt

diff --git a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
new file mode 100644
index 0000000..731a78f
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
+- "pullup-uV"	Pull up voltage in micro volts
+- "pullup-ohm"	Pull up resistor value in ohms
+- "pulldown-ohm" Pull down resistor value in ohms
+- "connected-positive" Always ON, If not specified.
+		Status change is possible, value (1) is assigned.
+- "io-channels"	Channel node of ADC to be used for
+		conversion.
+
+Read more about iio bindings at
+	Documentation/devicetree/bindings/iio/iio-bindings.txt
+	
+Example:
+	ncp15wb473@0 {
+		compatible = "ntc,ncp15wb473";
+		pullup-uV = <1800000>;
+		pullup-ohm = <47000>;
+		pulldown-ohm = <0>;
+		io-channels = <&adc 3>;
+	};
diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index b5f63f9..81d5bdc 100644
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
@@ -125,6 +141,76 @@ struct ntc_data {
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
+	result = pdata->pullup_uV * (s64) val;
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
+static int ntc_thermistor_parse_dt(struct ntc_thermistor_platform_data *pdata,
+						struct platform_device *pdev)
+{
+	struct iio_channel *chan;
+	struct device_node *np = pdev->dev.of_node;
+
+	if (!np)
+		return -ENODEV;
+
+	chan = iio_channel_get(&pdev->dev, NULL);
+	if (IS_ERR(chan))
+		return IS_ERR(chan);
+
+	of_property_read_u32(np, "pullup-uV", &pdata->pullup_uV);
+	of_property_read_u32(np, "pullup-ohm", &pdata->pullup_ohm);
+	of_property_read_u32(np, "pulldown-ohm", &pdata->pulldown_ohm);
+
+	if (of_find_property(np, "connected-positive", NULL))
+		pdata->connect = NTC_CONNECTED_POSITIVE;
+	else /* status change should be possible if not always on. */
+		pdata->connect = NTC_CONNECTED_GROUND;
+
+	pdata->chan = chan;
+	pdata->read_uV = ntc_adc_iio_read;
+
+	return 0;
+}
+#else
+static int ntc_thermistor_parse_dt(struct ntc_thermistor_platform_data *pdata,
+						struct platform_device *pdev)
+{
+	return -ENODEV;
+}
+#endif
+
 static inline u64 div64_u64_safe(u64 dividend, u64 divisor)
 {
 	if (divisor == 0 && dividend == 0)
@@ -259,7 +345,7 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
 		return data->pdata->read_ohm();
 
 	if (data->pdata->read_uV) {
-		read_uV = data->pdata->read_uV();
+		read_uV = data->pdata->read_uV(data->pdata);
 		if (read_uV < 0)
 			return read_uV;
 		return get_ohm_of_thermistor(data, read_uV);
@@ -311,9 +397,22 @@ static const struct attribute_group ntc_attr_group = {
 
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
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	ret = ntc_thermistor_parse_dt(pdata, pdev);
+	if (ret == -EPROBE_DEFER)
+		return ret;
+	else if (ret < 0)
+		pdata = pdev->dev.platform_data;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
@@ -349,11 +448,13 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
+	pdev_id = of_id ? of_id->data : platform_get_device_id(pdev);
+
 	data->dev = &pdev->dev;
 	data->pdata = pdata;
-	strlcpy(data->name, pdev->id_entry->name, sizeof(data->name));
+	strncpy(data->name, pdev_id->name, sizeof(data->name));
 
-	switch (pdev->id_entry->driver_data) {
+	switch (pdev_id->driver_data) {
 	case TYPE_NCPXXWB473:
 		data->comp = ncpXXwb473;
 		data->n_comp = ARRAY_SIZE(ncpXXwb473);
@@ -364,8 +465,7 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(&pdev->dev, "Unknown device type: %lu(%s)\n",
-				pdev->id_entry->driver_data,
-				pdev->id_entry->name);
+				pdev_id->driver_data, pdev_id->name);
 		return -EINVAL;
 	}
 
@@ -384,39 +484,34 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
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
+	iio_channel_release(pdata->chan);
 	return ret;
 }
 
 static int ntc_thermistor_remove(struct platform_device *pdev)
 {
 	struct ntc_data *data = platform_get_drvdata(pdev);
+	struct ntc_thermistor_platform_data *pdata = data->pdata;
 
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
+	iio_channel_release(pdata->chan);
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
index 88734e8..6cf5081 100644
--- a/include/linux/platform_data/ntc_thermistor.h
+++ b/include/linux/platform_data/ntc_thermistor.h
@@ -39,13 +39,17 @@ struct ntc_thermistor_platform_data {
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

