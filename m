Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3AXA76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:59:58 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64118 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3AXA7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:59:53 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-75-510087879891
Message-id: <5100878F.1010500@samsung.com>
Date: Thu, 24 Jan 2013 09:59:59 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] extcon: arizona: Use regulated mode for microphone
 supply when detecting
References: <1358957029-5421-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1358957029-5421-5-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1358957029-5421-5-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zLd32doZAg3VrxC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG9duXWQtWqFV8bDrD3MD4Ua6LkYNDQsBE4uE0li5GTiBTTOLC
	vfVsXYxcHEICyxglln9ZwgSRMJF4e28CO0RiOqPE06+/mCGcTiaJ718eMYJM4hXQkrjeUQRi
	sgioSkzYaArSywYU3f/iBhtIWFQgQuJXPwdImFdAUOLH5HssIGERoPG/71eChJkFCiTmHe0A
	mycskCxx5qktSFhIYC6jxJK1iiBhToFQiXV35SCqdST2t05jg7DlJTaveQt2loRAM7vEh1c/
	wI5nERCQ+Db5EAvEs7ISmw4wQ/wkKXFwxQ2WCYxis5DcMwvJ2FlIxi5gZF7FKJpakFxQnJSe
	a6RXnJhbXJqXrpecn7uJERIH0jsYVzVYHGIU4GBU4uGtUGcIFGJNLCuuzD3EKMHBrCTCq1YP
	FOJNSaysSi3Kjy8qzUktPsSYDHTgRGYp0eR8YIzmlcQbGhsYGxpaGpqZWpoakCasJM7LeOpJ
	gJBAemJJanZqakFqEcwWJg5OqQZGo2eqi5ks2A/1Hz4779MVxT1W0ouXroj6ZKF4LOfLhB/f
	1YU87h8CBlPiDXnNyFy78o+zDly+vUJgyyPGU4Fz7TmjnNKbP0vGX33flH5t75Tg5MdWks7O
	y2fzm3h6vT58J9hu9W7GwiqJBxp/d4S/snl22P6aRwPv6XUPAno++0t/+Rp9oSdUiaU4I9FQ
	i7moOBEAdHTnT8cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd32doZAg5cT+Swu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxvXbl1kLVqhVfGw6w9zA
	+FGui5GTQ0LAROLtvQnsELaYxIV769m6GLk4hASmM0o8/fqLGcLpZJL4/uURYxcjBwevgJbE
	9Y4iEJNFQFViwkZTkF42oOj+FzfYQMKiAhESv/o5QMK8AoISPybfYwEJiwCt+n2/EiTMLFAg
	Me9oB9g8YYFkiTNPbUHCQgJzGSWWrFUECXMKhEqsuysHUa0jsb91GhuELS+xec1b5gmMArOQ
	zJ+FpGwWkrIFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLj7Jn0DsZVDRaHGAU4GJV4
	eCvUGQKFWBPLiitzDzFKcDArifCq1QOFeFMSK6tSi/Lji0pzUosPMSYDPT+RWUo0OR+YAvJK
	4g2NTcyMLI3MjE3MjY1JE1YS52U89SRASCA9sSQ1OzW1ILUIZgsTB6dUAyNvCvPfNnHnp9PL
	I5fcrD3tGXvv9ATLKZohUf+Zf1g/fM7WkHtmW2P0tY/Fd8oXhe/n8+at7ZTqX+Ku2ZC38UqC
	/M2wh96Z9zwOqQX9yJzVXqDibXtmbnWQnzh73f5N15/KKXXYevwxMdyqtq1jz4MdPPpTv0/R
	Dd/1Y1L338txFx96xPxW3KvEUpyRaKjFXFScCACSlPn19wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 01:03 AM, Mark Brown wrote:
> When starting microphone detection some headsets should be exposed to
> the fully regulated microphone bias in order to ensure that they behave
> in an optimal fashion.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |   62 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index d7e1047..3aacacc 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -27,6 +27,8 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/extcon.h>
>  
> +#include <sound/soc.h>
> +
>  #include <linux/mfd/arizona/core.h>
>  #include <linux/mfd/arizona/pdata.h>
>  #include <linux/mfd/arizona/registers.h>
> @@ -113,6 +115,40 @@ static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
>  	dev_dbg(arizona->dev, "Set jack polarity to %d\n", mode);
>  }
>  
> +static void arizona_extcon_pulse_micbias(struct arizona_extcon_info *info)
> +{
> +	struct arizona *arizona = info->arizona;
> +	const char *widget;
> +	int ret;
> +
> +	if (arizona->dapm) {
> +		switch (info->micd_modes[0].bias) {
> +		case 1:
> +			widget = "MICBIAS1";
> +			break;
> +		case 2:
> +			widget = "MICBIAS2";
> +			break;
> +		case 3:
> +			widget = "MICBIAS3";
> +			break;
> +		default:
> +			widget = "MICVDD";
> +			break;
> +		}
> +
> +		ret = snd_soc_dapm_force_enable_pin(arizona->dapm, widget);
> +		if (ret != 0)
> +			dev_warn(arizona->dev, "Failed to enable %s: %d\n",
> +				 widget, ret);
> +
> +		ret = snd_soc_dapm_disable_pin(arizona->dapm, widget);
> +		if (ret != 0)
> +			dev_warn(arizona->dev, "Failed to disable %s: %d\n",
> +				 widget, ret);
> +	}
> +}
> +
>  static void arizona_start_mic(struct arizona_extcon_info *info)
>  {
>  	struct arizona *arizona = info->arizona;
> @@ -122,6 +158,15 @@ static void arizona_start_mic(struct arizona_extcon_info *info)
>  	/* Microphone detection can't use idle mode */
>  	pm_runtime_get(info->dev);
>  
> +	if (info->detecting) {
> +		ret = regulator_allow_bypass(info->micvdd, false);
> +		if (ret != 0) {
> +			dev_err(arizona->dev,
> +				"Failed to regulate MICVDD: %d\n",
> +				ret);
> +		}
> +	}
> +
>  	ret = regulator_enable(info->micvdd);
>  	if (ret != 0) {
>  		dev_err(arizona->dev, "Failed to enable MICVDD: %d\n",
> @@ -151,6 +196,7 @@ static void arizona_stop_mic(struct arizona_extcon_info *info)
>  {
>  	struct arizona *arizona = info->arizona;
>  	bool change;
> +	int ret;
>  
>  	regmap_update_bits_check(arizona->regmap, ARIZONA_MIC_DETECT_1,
>  				 ARIZONA_MICD_ENA, 0,
> @@ -162,6 +208,12 @@ static void arizona_stop_mic(struct arizona_extcon_info *info)
>  		regmap_write(arizona->regmap, 0x80, 0x0);
>  	}
>  
> +	ret = regulator_allow_bypass(info->micvdd, true);
> +	if (ret != 0) {
> +		dev_err(arizona->dev, "Failed to bypass MICVDD: %d\n",
> +			ret);
> +	}
> +
>  	if (change) {
>  		regulator_disable(info->micvdd);
>  		pm_runtime_mark_last_busy(info->dev);
> @@ -564,6 +616,8 @@ static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
>  
>  	info->hpdet_active = true;
>  
> +	arizona_extcon_pulse_micbias(info);
> +
>  	ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000, 0x4000);
>  	if (ret != 0)
>  		dev_warn(arizona->dev, "Failed to do magic: %d\n", ret);
> @@ -649,6 +703,13 @@ static irqreturn_t arizona_micdet(int irq, void *data)
>  			dev_err(arizona->dev, "Headset report failed: %d\n",
>  				ret);
>  
> +		/* Don't need to regulate for button detection */
> +		ret = regulator_allow_bypass(info->micvdd, false);
> +		if (ret != 0) {
> +			dev_err(arizona->dev, "Failed to bypass MICVDD: %d\n",
> +				ret);
> +		}
> +
>  		info->mic = true;
>  		info->detecting = false;
>  		goto handled;
> @@ -716,6 +777,7 @@ static irqreturn_t arizona_micdet(int irq, void *data)
>  			input_report_key(info->input,
>  					 arizona_lvl_to_key[i].report, 0);
>  		input_sync(info->input);
> +		arizona_extcon_pulse_micbias(info);
>  	}
>  
>  handled:

This patch happen build error related to soc-dapm. You should add 'CONFIG_SND_SOC'
dependency to drivers/extcon/Kconfig for extcon-arizona driver.

drivers/built-in.o: In function `arizona_extcon_pulse_micbias':
/home/cwchoi00/kernel/git.kernel.org/extcon/drivers/extcon/extcon-arizona.c:140: undefined reference
to `snd_soc_dapm_force_enable_pin'
/home/cwchoi00/kernel/git.kernel.org/extcon/drivers/extcon/extcon-arizona.c:145: undefined reference
to `snd_soc_dapm_disable_pin'
/home/cwchoi00/kernel/git.kernel.org/extcon/drivers/extcon/extcon-arizona.c:145: undefined reference
to `snd_soc_dapm_disable_pin'

Thanks,
Chanwoo Choi

