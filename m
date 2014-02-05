Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbaBEFBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 00:01:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:58847 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaBEFBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 00:01:02 -0500
X-AuditID: cbfee690-b7f266d00000287c-ac-52f1c58c3d6d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        linux-pwm@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org>
In-reply-to: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org>
Subject: Re: [PATCH] backlight: add PWM dependencies
Date: Wed, 05 Feb 2014 14:01:00 +0900
Message-id: <000401cf222f$43263b20$c972b160$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8hqKj2xYUfuaEcQbyaRYA75G2MqAAhRGYQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zY92eox+DDKatVLC4vPASq8WUP8uZ
	LDY9vsZqcXnXHDaLu3dXMVr83DWPxYHNY+esu+wed67tYfPYvKTeo2/LKkaPz5vkAlijuGxS
	UnMyy1KL9O0SuDLefj/FWtAqV7FqyzXmBsbJkl2MnBwSAiYSd983skLYYhIX7q1n62Lk4hAS
	WMYocaN9BRtM0akdWxghEosYJRoP72GBcH4xSvRtbGcGqWITUJP48uUwO4gtIqAn8eZrCztI
	EbPANkaJ+5/+ADkcQB3uEs+OKoCYnAIeEiea+UDKhUGuOPyPEcRmEVCV2Hn1PlA1OwevgK3E
	THeQKK+AoMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlBhkoIaAu8eivLsR+I4nTZ95BlYhI7Hvx
	Dux6CYFH7BIPeu6zQGwSkPg2+RALRK+sxKYDzBDfSkocXHGDZQKjxCwkm2ch2TwLyeZZSFYs
	YGRZxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iRESrRN2MN47YH2IMRlo/URmKdHkfGC055XE
	GxqbGVmYmpgaG5lbmpEmrCTOq/YoKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY+jzaPV5
	U+REW+Sc9xszTZ6yg3/C6Xy20CPqcrmTd23fqL+0qHNl0UKzB69Sf+1b6BSi+SZ5ovmC0Idn
	V1599EpCeuH28HZefr7apGmfatoersiZKjHb6RbPtEX7K9ZdcomeN+cnX3X4YuONaW/NRET/
	hxyMmvhQ/tkpYR2j1FXTpky68bNL2UGJpTgj0VCLuag4EQBN6d6b7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAd2eox+DDOaelba4vPASq8WUP8uZ
	LDY9vsZqcXnXHDaLu3dXMVr83DWPxYHNY+esu+wed67tYfPYvKTeo2/LKkaPz5vkAlijGhht
	MlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AuUFIoS8wp
	BQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmvP1+irWgVa5i1ZZrzA2MkyW7GDk5
	JARMJE7t2MIIYYtJXLi3nq2LkYtDSGARo0Tj4T0sEM4vRom+je3MIFVsAmoSX74cZgexRQT0
	JN58bWEHKWIW2MYocf/THyCHA6jDXeLZUQUQk1PAQ+JEMx9IuTDQsruH/4EtYxFQldh59T5Q
	NTsHr4CtxEx3kCivgKDEj8n3WEBsZgEtifU7jzNB2PISm9e8ZQYZKCGgLvHory7EfiOJ02fe
	QZWISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93E
	CE4Fz6R2MK5ssDjEKMDBqMTDayD8MUiINbGsuDL3EKMEB7OSCG9iN1CINyWxsiq1KD++qDQn
	tfgQYzLQmxOZpUST84FpKq8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUw
	W5g4OKUaGHdd2JfZxxKWyev3cYH07SUmLfW111gEt3u/v/igtzBDRImvXML5aeutyMuFfMI8
	dRP2baj8Ul/xTdPo20RJV69tj8VETm1wVp6wNDX989Ob1amXd2e373Fc9DBlntWqlfKspQXX
	N2sdL5wyS6fj+TeVgKxHLt6tkixrr7LIR05h1g86k3RPQImlOCPRUIu5qDgRAB9htQpJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 04, 2014 9:57 PM, Linus Walleij wrote:
> 
> In some compilations the LM3630A and LP855X backlight drivers
> fail like this:
> 
> drivers/built-in.o: In function `lm3630a_pwm_ctrl':
> drivers/video/backlight/lm3630a_bl.c:168: undefined reference to `pwm_config'
> drivers/video/backlight/lm3630a_bl.c:172: undefined reference to `pwm_disable'
> drivers/video/backlight/lm3630a_bl.c:170: undefined reference to `pwm_enable'
> drivers/built-in.o: In function `lp855x_pwm_ctrl':
> drivers/video/backlight/lp855x_bl.c:249: undefined reference to `pwm_config'
> drivers/video/backlight/lp855x_bl.c:253: undefined reference to `pwm_disable'
> drivers/video/backlight/lp855x_bl.c:251: undefined reference to `pwm_enable'
> 
> This is because both drivers depend on the PWM framework, so
> add this dependency to their Kconfig entries.

However, even though, when CONFIG_PWM is not enabled, the problem
should not happen. pwm_config(),pwm_disable(), and pwm_enable()
are already defined for CONFIG_PWM=n case as below.

./include/linux/pwm.h
#if IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)
	.....
#else
static inline struct pwm_device *pwm_request(int pwm_id, const char *label)
{
        return ERR_PTR(-ENODEV);
}

static inline void pwm_free(struct pwm_device *pwm)
{
}

static inline int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
{
        return -EINVAL;
}

static inline int pwm_enable(struct pwm_device *pwm)
{
        return -EINVAL;
}

static inline void pwm_disable(struct pwm_device *pwm)
{
}
#endif

Is there 'drivers/pwm/core.o'?
I reproduced this problem by commenting core.o with CONFIG_PWM=y.

.config
CONFIG_PWM=y

./drivers/pwm/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_PWM)              += core.o
+#obj-$(CONFIG_PWM)             += core.o

In this case, the following build errors happen.
Even though, CONFIG_PWM is enabled, the same errors happen.
Would you give me the more detailed information?
Ex. how to reproduce the problem.

drivers/built-in.o: In function `lm3630a_pwm_ctrl':
drivers/video/backlight/lm3630a_bl.c:168: undefined reference to `pwm_config'
drivers/video/backlight/lm3630a_bl.c:172: undefined reference to `pwm_disable'
drivers/video/backlight/lm3630a_bl.c:170: undefined reference to `pwm_enable'
drivers/built-in.o: In function `lm3630a_probe':
drivers/video/backlight/lm3630a_bl.c:422: undefined reference to `devm_pwm_get'
drivers/built-in.o: In function `lp855x_pwm_ctrl':
drivers/video/backlight/lp855x_bl.c:249: undefined reference to `pwm_config'
drivers/video/backlight/lp855x_bl.c:253: undefined reference to `pwm_disable'
drivers/video/backlight/lp855x_bl.c:251: undefined reference to `pwm_enable'
drivers/video/backlight/lp855x_bl.c:242: undefined reference to `devm_pwm_get'

Thank you.

Best regards,
Jingoo Han

> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/video/backlight/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 5a3eb2ecb525..0604c3348761 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -371,6 +371,7 @@ config BACKLIGHT_AAT2870
>  config BACKLIGHT_LM3630A
>  	tristate "Backlight Driver for LM3630A"
>  	depends on BACKLIGHT_CLASS_DEVICE && I2C
> +	depends on PWM
>  	select REGMAP_I2C
>  	help
>  	  This supports TI LM3630A Backlight Driver
> @@ -387,6 +388,7 @@ config BACKLIGHT_LM3639
>  config BACKLIGHT_LP855X
>  	tristate "Backlight driver for TI LP855X"
>  	depends on BACKLIGHT_CLASS_DEVICE && I2C
> +	depends on PWM
>  	help
>  	  This supports TI LP8550, LP8551, LP8552, LP8553, LP8555, LP8556 and
>  	  LP8557 backlight driver.
> --
> 1.8.5.3

