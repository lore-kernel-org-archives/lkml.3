Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab3GPAtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:49:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10696 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab3GPAtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:49:15 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-0c-51e49889208a
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
 <1373902022-20439-3-git-send-email-maxime.ripard@free-electrons.com>
In-reply-to: <1373902022-20439-3-git-send-email-maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 2/3] video: hx8357: Make IM pins optional
Date: Tue, 16 Jul 2013 09:49:12 +0900
Message-id: <003501ce81be$4a945ed0$dfbd1c70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIBBDsUjLqA0lXv1EE0kvWfH9ISAAEpSs6fmPgnE4A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zQ93OGU8CDV6/N7OYs34Nm0XHtcVM
	Fk9+rme1uLzwEqvFpsfXWC1O9H0AcnfNYbPYumkvs8W6hy+YLF407WB34PKYdXU2o8eTTRcZ
	PV5duMPicWLGbxaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvjxqN9bAX/5Sq6Fm5j
	bGDcLNHFyMEhIWAi0XPDqYuRE8gUk7hwbz1bFyMXh5DAMkaJ/+veMcHUXF1cAxFfxCgx5cUG
	qKJfjBL3b+9lBOlmE1CT+PLlMDuILSKQKjFv03RWkCJmgVVMEjM3r2KE6JjJKPFr+mxWkLGc
	AsES+zrKQBqEBWwl5i4/BzaIRUBVYtbO40wgNq+ApcSZNYtYIGxBiR+T74HZzAJaEuuhapgF
	5CU2r3nLDPGCgsSOs68ZIY6wktg6o5MVokZEYt+Ld2A3SAhM5JC48O0AM8QyAYlvkw+xQLwp
	K7HpANQcSYmDK26wTGCUmIVk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPSi0z0ihNzi0vz0vWS
	83M3MULifcIOxnsHrA8xJgOtn8gsJZqcD0wXeSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJ
	pCeWpGanphakFsUXleakFh9iZOLglGpgrJfl3CjE5vjpjo/MB0k1HRurRgf3pMRZ3pLFVZFL
	WE8Lc7Y+brd8evlZ5OkEx518ZbOnLHzV/vnVI08VrrtJkcIp0rOaGdVSLpxO8blaacXSPWvr
	czvHh9yhf4KsuBg1Od91He0Qet2rPsn8xh+Vz3VHqi8Wzd3Y8TSh1tf2zDGeRYlyZz8psRRn
	JBpqMRcVJwIAvX91Ww0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsVy+t9jAd3OGU8CDX4/NrSYs34Nm0XHtcVM
	Fk9+rme1uLzwEqvFpsfXWC1O9H0AcnfNYbPYumkvs8W6hy+YLF407WB34PKYdXU2o8eTTRcZ
	PV5duMPicWLGbxaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYR1jxo1H+9gK/stVdC3cxtjAuFmii5GDQ0LAROLq4pouRk4gU0ziwr31bF2MXBxC
	AosYJaa82ADl/GKUuH97LyNIFZuAmsSXL4fZQWwRgVSJeZums4IUMQusYpKYuXkVI0THTEaJ
	X9Nns4Ks4BQIltjXUQbSICxgKzF3+TmwQSwCqhKzdh5nArF5BSwlzqxZxAJhC0r8mHwPzGYW
	0JJYD1XDLCAvsXnNW2aIUxUkdpx9zQhxhJXE1hmdrBA1IhL7XrxjnMAoNAvJqFlIRs1CMmoW
	kpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLTyTOpHYwrGywOMQpwMCrx8ErwPAkU
	Yk0sK67MPcQowcGsJMJrJwwU4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5HxgqssriTc0NjEz
	sjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBkaeUIvnP19r5UtUCRvHFznd
	d7IukDqy+0nfrqf/F2u8mqO9c5bD86hF22IX7N9xU4Bn1hGdZS6xckcS1txQf8B96ohn9p8z
	1zQDp0o/sFTeXKhp3XL7+n5T9TbLDje10nUHt15/LXm74eeTDSlv+bhN7uZsDFfnP3FUuDh6
	UUigwtbIqB1Tm98rsRRnJBpqMRcVJwIATzB1o2sDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 16, 2013 12:27 AM, Maxime Ripard wrote:
> 
> The IM pins of the HX8357 controller are used to define the interface
> used to feed pixel stream to the LCD panel.
> 
> Most of the time, these pins are directly routed to either the ground or
> the VCC to set their values.
> 
> Remove the need to assign GPIOs to these pins when we are in such a case.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/video/backlight/hx8357.c | 52 +++++++++++++++++++++++-----------------
>  1 file changed, 30 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/hx8357.c
> index a0482b5..ed94796 100644
> --- a/drivers/video/backlight/hx8357.c
> +++ b/drivers/video/backlight/hx8357.c
> @@ -76,6 +76,7 @@ struct hx8357_data {
>  	unsigned		reset;
>  	struct spi_device	*spi;
>  	int			state;
> +	bool			use_im_pins;
>  };
> 
>  static u8 hx8357_seq_power[] = {
> @@ -250,9 +251,11 @@ static int hx8357_lcd_init(struct lcd_device *lcdev)
>  	 * Set the interface selection pins to SPI mode, with three
>  	 * wires
>  	 */
> -	gpio_set_value_cansleep(lcd->im_pins[0], 1);
> -	gpio_set_value_cansleep(lcd->im_pins[1], 0);
> -	gpio_set_value_cansleep(lcd->im_pins[2], 1);
> +	if (lcd->use_im_pins) {
> +		gpio_set_value_cansleep(lcd->im_pins[0], 1);
> +		gpio_set_value_cansleep(lcd->im_pins[1], 0);
> +		gpio_set_value_cansleep(lcd->im_pins[2], 1);
> +	}
> 
>  	/* Reset the screen */
>  	gpio_set_value(lcd->reset, 1);
> @@ -424,26 +427,31 @@ static int hx8357_probe(struct spi_device *spi)
>  		return -EINVAL;
>  	}
> 
> -	for (i = 0; i < HX8357_NUM_IM_PINS; i++) {
> -		lcd->im_pins[i] = of_get_named_gpio(spi->dev.of_node,
> -						"im-gpios", i);
> -		if (lcd->im_pins[i] == -EPROBE_DEFER) {
> -			dev_info(&spi->dev, "GPIO requested is not here yet, deferring the probe\n");
> -			return -EPROBE_DEFER;
> -		}
> -		if (!gpio_is_valid(lcd->im_pins[i])) {
> -			dev_err(&spi->dev, "Missing dt property: im-gpios\n");
> -			return -EINVAL;
> +	if (of_find_property(spi->dev.of_node, "im-gpios", NULL)) {
> +		lcd->use_im_pins = 1;
> +
> +		for (i = 0; i < HX8357_NUM_IM_PINS; i++) {
> +			lcd->im_pins[i] = of_get_named_gpio(spi->dev.of_node,
> +							    "im-gpios", i);
> +			if (lcd->im_pins[i] == -EPROBE_DEFER) {
> +				dev_info(&spi->dev, "GPIO requested is not here yet, deferring the
> probe\n");
> +				return -EPROBE_DEFER;
> +			}
> +			if (!gpio_is_valid(lcd->im_pins[i])) {
> +				dev_err(&spi->dev, "Missing dt property: im-gpios\n");
> +				return -EINVAL;
> +			}
> +
> +			ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
> +						    GPIOF_OUT_INIT_LOW, "im_pins");

This makes a checkpatch warning such as 'WARNING: line over 80 characters'.
How about the following?

			ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
						GPIOF_OUT_INIT_LOW, "im_pins");

> +			if (ret) {
> +				dev_err(&spi->dev, "failed to request gpio %d: %d\n",
> +					lcd->im_pins[i], ret);
> +				return -EINVAL;
> +			}
>  		}
> -
> -		ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
> -					GPIOF_OUT_INIT_LOW, "im_pins");
> -		if (ret) {
> -			dev_err(&spi->dev, "failed to request gpio %d: %d\n",
> -				lcd->im_pins[i], ret);
> -			return -EINVAL;
> -		}
> -	}
> +	} else
> +		lcd->use_im_pins = 0;

According to the 'Documentation/CodingStyle', braces are necessary as below.

	} else {
		lcd->use_im_pins = 0;
	}


Others look good.
Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
>  	lcdev = lcd_device_register("mxsfb", &spi->dev, lcd, &hx8357_ops);
>  	if (IS_ERR(lcdev)) {
> --
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

