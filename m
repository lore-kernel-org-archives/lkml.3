Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab3GPCEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:04:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34722 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab3GPCES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:04:18 -0400
X-AuditID: cbfee691-b7fef6d000002d62-b5-51e4aa19bdb8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Maxime Ripard'" <maxime.ripard@free-electrons.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Alexandre Belloni'" <alexandre.belloni@free-electrons.com>,
        hector.palacios@digi.com,
        "'Thomas Petazzoni'" <thomas@free-electrons.com>,
        plagnioj@jcrosoft.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <1373902022-20439-1-git-send-email-maxime.ripard@free-electrons.com>
 <1373902022-20439-4-git-send-email-maxime.ripard@free-electrons.com>
In-reply-to: <1373902022-20439-4-git-send-email-maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 3/3] fb: backlight: HX8357: Add HX8369 support
Date: Tue, 16 Jul 2013 11:04:09 +0900
Message-id: <003601ce81c8$c2573320$47059960$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIBBDsUjLqA0lXv1EE0kvWfH9ISAAJnXsBVmO5FAlA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zA12pVU8CDb7dZLKYs34Nm0XHtcVM
	Fk9+rme1uLzwEqvFpsfXWC1O9H0AcnfNYbPYumkvs8W6hy+YLF407WB34PKYdXU2o8eTTRcZ
	PV5duMPicWLGbxaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSuj7Vwfa8EKr4rlK54z
	NzBOt+li5OSQEDCRuNG2lA3CFpO4cG89mC0ksIxRYup7QZia5p4d7F2MXEDx6YwSc15vhir6
	xSix6240iM0moCbx5cthdhBbRCBVYt6m6awgDcwCq5gkZm5exQjRPZNR4snrXhaQKk6BYIn7
	L36AdQgLOElsXPiaEcRmEVCV6F/9jgnE5hWwlJgz8ywbhC0o8WPyPbBeZgEtifU7jzNB2PIS
	m9e8ZYY4VUFix1mIOSICVhI/v55jhqgRkdj34h3YERICEzkkrm3Yww6xTEDi2+RDQEM5gBKy
	EpsOQM2RlDi44gbLBEaJWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9yFSvODG3uDQvXS85
	P3cTIyTiJ+5gvH/A+hBjMtD6icxSosn5wISRVxJvaGxmZGFqYmpsZG5pRpqwkjiveot1oJBA
	emJJanZqakFqUXxRaU5q8SFGJg5OqQbGNOWoexL75NrE6zkUT2i78brmV72o+/VLc0Ki/+qT
	Huec/Zd/Cv3/69ZNp8o9Qg0T1vHdW+TbW9y320h8RVVQUNdz9g+psYcOPJv8tqrMQndnLfdM
	/+/vI28YW/LGPxNdcmNBxUyFoK2lv4/UTPCYZ3krTnjn23MbrZ86Pb/ksUHli4rlv6AJSizF
	GYmGWsxFxYkA+b+ZMA4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jQV3JVU8CDV6ftbSYs34Nm0XHtcVM
	Fk9+rme1uLzwEqvFpsfXWC1O9H0AcnfNYbPYumkvs8W6hy+YLF407WB34PKYdXU2o8eTTRcZ
	PV5duMPicWLGbxaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYR1jRtu5PtaCFV4Vy1c8Z25gnG7TxcjJISFgItHcs4MdwhaTuHBvPVsXIxeHkMB0
	Rok5rzezgSSEBH4xSuy6Gw1iswmoSXz5chisQUQgVWLepumsIA3MAquYJGZuXsUI0T2TUeLJ
	614WkCpOgWCJ+y9+gHUICzhJbFz4mhHEZhFQlehf/Y4JxOYVsJSYM/MsG4QtKPFj8j2wXmYB
	LYn1O48zQdjyEpvXvGWGOFVBYsdZiDkiAlYSP7+eY4aoEZHY9+Id4wRGoVlIRs1CMmoWklGz
	kLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcUJ5J7WBc2WBxiFGAg1GJh1eC50mg
	EGtiWXFl7iFGCQ5mJRFeO2GgEG9KYmVValF+fFFpTmrxIcZkoE8nMkuJJucDk11eSbyhsYmZ
	kaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAmxL85q/Vr2nqdlvO1r2MK
	ptrd8VWQtxKX2un66rDf5IZLmXWljfJHnkgFXeE32yD9Q+mm1Eduz+0Rh65qGC+q5VytdF4p
	Y4XFBsbrDV2R4nMsM68xib9MXTnv4Yc/Suo+x4tN7xj+FXHNPKGXF1bAwTXxCTPPdoPcZW/2
	126QFzvIumj2zatKLMUZiYZazEXFiQC+iwW1bAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 16, 2013 12:27 AM, Maxime Ripard wrote:
> 
> From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Add support for the Himax HX8369 controller as it is quite similar to the
> hx8357.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Hi Maxime Ripard,

I reviewed this patch with Himax HX8369 datasheet.
I cannot find any problems. It looks good.

However, if possible, please add comment on huge delays such as
msleep(120), msleep(100), etc.


Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/hx8357.c | 203 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 188 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/hx8357.c
> index ed94796..b035fab 100644
> --- a/drivers/video/backlight/hx8357.c
> +++ b/drivers/video/backlight/hx8357.c
> @@ -71,6 +71,18 @@
>  #define HX8357_SET_POWER_NORMAL		0xd2
>  #define HX8357_SET_PANEL_RELATED	0xe9
> 
> +#define HX8369_SET_DISPLAY_BRIGHTNESS		0x51
> +#define HX8369_WRITE_CABC_DISPLAY_VALUE		0x53
> +#define HX8369_WRITE_CABC_BRIGHT_CTRL		0x55
> +#define HX8369_WRITE_CABC_MIN_BRIGHTNESS	0x5e
> +#define HX8369_SET_POWER			0xb1
> +#define HX8369_SET_DISPLAY_MODE			0xb2
> +#define HX8369_SET_DISPLAY_WAVEFORM_CYC		0xb4
> +#define HX8369_SET_VCOM				0xb6
> +#define HX8369_SET_EXTENSION_COMMAND		0xb9
> +#define HX8369_SET_GIP				0xd5
> +#define HX8369_SET_GAMMA_CURVE_RELATED		0xe0
> +
>  struct hx8357_data {
>  	unsigned		im_pins[HX8357_NUM_IM_PINS];
>  	unsigned		reset;
> @@ -144,6 +156,61 @@ static u8 hx8357_seq_display_mode[] = {
>  	HX8357_SET_DISPLAY_MODE_RGB_INTERFACE,
>  };
> 
> +static u8 hx8369_seq_write_CABC_min_brightness[] = {
> +	HX8369_WRITE_CABC_MIN_BRIGHTNESS, 0x00,
> +};
> +
> +static u8 hx8369_seq_write_CABC_control[] = {
> +	HX8369_WRITE_CABC_DISPLAY_VALUE, 0x24,
> +};
> +
> +static u8 hx8369_seq_set_display_brightness[] = {
> +	HX8369_SET_DISPLAY_BRIGHTNESS, 0xFF,
> +};
> +
> +static u8 hx8369_seq_write_CABC_control_setting[] = {
> +	HX8369_WRITE_CABC_BRIGHT_CTRL, 0x02,
> +};
> +
> +static u8 hx8369_seq_extension_command[] = {
> +	HX8369_SET_EXTENSION_COMMAND, 0xff, 0x83, 0x69,
> +};
> +
> +static u8 hx8369_seq_display_related[] = {
> +	HX8369_SET_DISPLAY_MODE, 0x00, 0x2b, 0x03, 0x03, 0x70, 0x00,
> +	0xff, 0x00, 0x00, 0x00, 0x00, 0x03, 0x03, 0x00,	0x01,
> +};
> +
> +static u8 hx8369_seq_panel_waveform_cycle[] = {
> +	HX8369_SET_DISPLAY_WAVEFORM_CYC, 0x0a, 0x1d, 0x80, 0x06, 0x02,
> +};
> +
> +static u8 hx8369_seq_set_address_mode[] = {
> +	HX8357_SET_ADDRESS_MODE, 0x00,
> +};
> +
> +static u8 hx8369_seq_vcom[] = {
> +	HX8369_SET_VCOM, 0x3e, 0x3e,
> +};
> +
> +static u8 hx8369_seq_gip[] = {
> +	HX8369_SET_GIP, 0x00, 0x01, 0x03, 0x25, 0x01, 0x02, 0x28, 0x70,
> +	0x11, 0x13, 0x00, 0x00, 0x40, 0x26, 0x51, 0x37, 0x00, 0x00, 0x71,
> +	0x35, 0x60, 0x24, 0x07, 0x0f, 0x04, 0x04,
> +};
> +
> +static u8 hx8369_seq_power[] = {
> +	HX8369_SET_POWER, 0x01, 0x00, 0x34, 0x03, 0x00, 0x11, 0x11, 0x32,
> +	0x2f, 0x3f, 0x3f, 0x01, 0x3a, 0x01, 0xe6, 0xe6, 0xe6, 0xe6, 0xe6,
> +};
> +
> +static u8 hx8369_seq_gamma_curve_related[] = {
> +	HX8369_SET_GAMMA_CURVE_RELATED, 0x00, 0x0d, 0x19, 0x2f, 0x3b, 0x3d,
> +	0x2e, 0x4a, 0x08, 0x0e, 0x0f, 0x14, 0x16, 0x14, 0x14, 0x14, 0x1e,
> +	0x00, 0x0d, 0x19, 0x2f, 0x3b, 0x3d, 0x2e, 0x4a, 0x08, 0x0e, 0x0f,
> +	0x14, 0x16, 0x14, 0x14, 0x14, 0x1e,
> +};
> +
>  static int hx8357_spi_write_then_read(struct lcd_device *lcdev,
>  				u8 *txbuf, u16 txlen,
>  				u8 *rxbuf, u16 rxlen)
> @@ -242,6 +309,18 @@ static int hx8357_exit_standby(struct lcd_device *lcdev)
>  	return 0;
>  }
> 
> +static void hx8357_lcd_reset(struct lcd_device *lcdev)
> +{
> +	struct hx8357_data *lcd = lcd_get_data(lcdev);
> +
> +	gpio_set_value(lcd->reset, 1);
> +	usleep_range(10000, 12000);
> +	gpio_set_value(lcd->reset, 0);
> +	usleep_range(10000, 12000);
> +	gpio_set_value(lcd->reset, 1);
> +	msleep(120);
> +}
> +
>  static int hx8357_lcd_init(struct lcd_device *lcdev)
>  {
>  	struct hx8357_data *lcd = lcd_get_data(lcdev);
> @@ -257,14 +336,6 @@ static int hx8357_lcd_init(struct lcd_device *lcdev)
>  		gpio_set_value_cansleep(lcd->im_pins[2], 1);
>  	}
> 
> -	/* Reset the screen */
> -	gpio_set_value(lcd->reset, 1);
> -	usleep_range(10000, 12000);
> -	gpio_set_value(lcd->reset, 0);
> -	usleep_range(10000, 12000);
> -	gpio_set_value(lcd->reset, 1);
> -	msleep(120);
> -
>  	ret = hx8357_spi_write_array(lcdev, hx8357_seq_power,
>  				ARRAY_SIZE(hx8357_seq_power));
>  	if (ret < 0)
> @@ -359,6 +430,94 @@ static int hx8357_lcd_init(struct lcd_device *lcdev)
>  	return 0;
>  }
> 
> +static int hx8369_lcd_init(struct lcd_device *lcdev)
> +{
> +	int ret;
> +
> +	ret = hx8357_spi_write_array(lcdev, hx8369_seq_extension_command,
> +				ARRAY_SIZE(hx8369_seq_extension_command));
> +	if (ret < 0)
> +		return ret;
> +	usleep_range(10000, 12000);
> +
> +	ret = hx8357_spi_write_array(lcdev, hx8369_seq_display_related,
> +				ARRAY_SIZE(hx8369_seq_display_related));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = hx8357_spi_write_array(lcdev, hx8369_seq_panel_waveform_cycle,
> +				ARRAY_SIZE(hx8369_seq_panel_waveform_cycle));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = hx8357_spi_write_array(lcdev, hx8369_seq_set_address_mode,
> +				ARRAY_SIZE(hx8369_seq_set_address_mode));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = hx8357_spi_write_array(lcdev, hx8369_seq_vcom,
> +				ARRAY_SIZE(hx8369_seq_vcom));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = hx8357_spi_write_array(lcdev, hx8369_seq_gip,
> +				ARRAY_SIZE(hx8369_seq_gip));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = hx8357_spi_write_array(lcdev, hx8369_seq_power,
> +				ARRAY_SIZE(hx8369_seq_power));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = hx8357_spi_write_byte(lcdev, HX8357_EXIT_SLEEP_MODE);
> +	if (ret < 0)
> +		return ret;
> +
> +	msleep(120);
> +
> +	ret = hx8357_spi_write_array(lcdev, hx8369_seq_gamma_curve_related,
> +				ARRAY_SIZE(hx8369_seq_gamma_curve_related));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = hx8357_spi_write_byte(lcdev, HX8357_EXIT_SLEEP_MODE);
> +	if (ret < 0)
> +		return ret;
> +	usleep_range(1000, 1200);
> +
> +	ret = hx8357_spi_write_array(lcdev, hx8369_seq_write_CABC_control,
> +				ARRAY_SIZE(hx8369_seq_write_CABC_control));
> +	if (ret < 0)
> +		return ret;
> +	usleep_range(10000, 12000);
> +
> +	ret = hx8357_spi_write_array(lcdev,
> +			hx8369_seq_write_CABC_control_setting,
> +			ARRAY_SIZE(hx8369_seq_write_CABC_control_setting));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = hx8357_spi_write_array(lcdev,
> +			hx8369_seq_write_CABC_min_brightness,
> +			ARRAY_SIZE(hx8369_seq_write_CABC_min_brightness));
> +	if (ret < 0)
> +		return ret;
> +	usleep_range(10000, 12000);
> +
> +	ret = hx8357_spi_write_array(lcdev, hx8369_seq_set_display_brightness,
> +				ARRAY_SIZE(hx8369_seq_set_display_brightness));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = hx8357_spi_write_byte(lcdev, HX8357_SET_DISPLAY_ON);
> +	if (ret < 0)
> +		return ret;
> +	msleep(100);
> +
> +	return 0;
> +}
> +
>  #define POWER_IS_ON(pwr)	((pwr) <= FB_BLANK_NORMAL)
> 
>  static int hx8357_set_power(struct lcd_device *lcdev, int power)
> @@ -391,10 +550,24 @@ static struct lcd_ops hx8357_ops = {
>  	.get_power	= hx8357_get_power,
>  };
> 
> +static const struct of_device_id hx8357_dt_ids[] = {
> +	{
> +		.compatible = "himax,hx8357",
> +		.data = hx8357_lcd_init,
> +	},
> +	{
> +		.compatible = "himax,hx8369",
> +		.data = hx8369_lcd_init,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, hx8357_dt_ids);
> +
>  static int hx8357_probe(struct spi_device *spi)
>  {
>  	struct lcd_device *lcdev;
>  	struct hx8357_data *lcd;
> +	const struct of_device_id *match;
>  	int i, ret;
> 
>  	lcd = devm_kzalloc(&spi->dev, sizeof(*lcd), GFP_KERNEL);
> @@ -411,6 +584,10 @@ static int hx8357_probe(struct spi_device *spi)
> 
>  	lcd->spi = spi;
> 
> +	match = of_match_device(hx8357_dt_ids, &spi->dev);
> +	if (!match || !match->data)
> +		return -EINVAL;
> +
>  	lcd->reset = of_get_named_gpio(spi->dev.of_node, "gpios-reset", 0);
>  	if (!gpio_is_valid(lcd->reset)) {
>  		dev_err(&spi->dev, "Missing dt property: gpios-reset\n");
> @@ -460,7 +637,9 @@ static int hx8357_probe(struct spi_device *spi)
>  	}
>  	spi_set_drvdata(spi, lcdev);
> 
> -	ret = hx8357_lcd_init(lcdev);
> +	hx8357_lcd_reset(lcdev);
> +
> +	ret = ((int (*)(struct lcd_device *))match->data)(lcdev);
>  	if (ret) {
>  		dev_err(&spi->dev, "Couldn't initialize panel\n");
>  		goto init_error;
> @@ -483,12 +662,6 @@ static int hx8357_remove(struct spi_device *spi)
>  	return 0;
>  }
> 
> -static const struct of_device_id hx8357_dt_ids[] = {
> -	{ .compatible = "himax,hx8357" },
> -	{},
> -};
> -MODULE_DEVICE_TABLE(of, hx8357_dt_ids);
> -
>  static struct spi_driver hx8357_driver = {
>  	.probe  = hx8357_probe,
>  	.remove = hx8357_remove,
> --
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

