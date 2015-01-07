Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbbAGOX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:23:27 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19244 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbbAGOXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:23:25 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f126d000001e9a-54-54ad415a637d
Content-transfer-encoding: 8BIT
Message-id: <1420640600.32552.7.camel@AMDC1943>
Subject: Re: [PATCH v2] ARM: exynos_defconfig: Enable CONFIG_LOCKUP_DETECTOR
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Anand Moon <moon.linux@yahoo.com>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>,
        Kevin Hilman <khilman@linaro.org>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 07 Jan 2015 15:23:20 +0100
In-reply-to: <157605903.5809859.1420638996780.JavaMail.yahoo@jws10677.mail.bf1.yahoo.com>
References: <1420635542-7202-1-git-send-email-moon.linux@yahoo.com>
 <1420637261.32552.4.camel@AMDC1943>
 <157605903.5809859.1420638996780.JavaMail.yahoo@jws10677.mail.bf1.yahoo.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t/xa7pRjmtDDM6dMLc4u+wgm8XR3wUW
	/Y9fM1t8PbyC0WLT42usFpd3zWGzmHF+H5PF7cu8FtfvT2O2eLziLbvFlUun2CymH3/LatH+
	dy+bA69HS3MPm8fshossHn+fX2fxWLznJZPHplWdbB53ru1h89i8pN6jb8sqRo/Pm+Q8Zs06
	zBTAFcVlk5Kak1mWWqRvl8CVcfDYOvaCv/wVk6buZmxgfM/TxcjJISFgIrH98FJmCFtM4sK9
	9WxdjFwcQgJLGSWmXn7FApLgFRCU+DH5HpDNwcEsIC9x5FI2SJhZQF1i0rxFYL1CAp8ZJbZ2
	WEKU60t0Nd1hBLGFBXwkTtyeCTaGTcBYYvPyJWwgtoiAqsSD1qusEHNes0i83QI2kwUoPu/k
	P7BVnALREq/7zCHO2cEo0Xf4IBtIXEJAWaKx320Co8AsJMfNQjhuFpLjFjAyr2IUTS1NLihO
	Ss811CtOzC0uzUvXS87P3cQIiaMvOxgXH7M6xCjAwajEw1vQtyZEiDWxrLgy9xCjBAezkgjv
	m19AId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYx9rIV3maQupK40ib1W9kD/luqS4AdMQgYMXNWr
	arew/hbJWDFvCjf/ObXgG1V/C69ve33m8t2iLhanGynGTM8rmENv2N3VU1ef+sPj9Wvt7B0q
	51q8s2NfH1BPUEh/OWOxaUr2/kLuBZv9PAWsnlkL3ew5//mUxeQXvy9+cWBJSs+eqviB0U6J
	pTgj0VCLuag4EQDmsZmmgQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2015-01-07 at 13:56 +0000, Anand Moon wrote:
> Hi Kszysztof Kozlowski,
> 
> I picked up the bellow line from 
> 
> 
> Documentation/locking/lockdep-design.txt  line no 18
> 
> I understand that by enabling this flag we could detect possible 
> 
> deadlock situation with the kernel. Sorry for the noise.

...and lockdep-design.txt describes LOCKDEP. Not LOCKUP. So why you are
enabling lockup?

Best regards,
Krzysztof

> 
> 
> -Anand Moon
> 
> 
> 
> On Wednesday, January 7, 2015 6:57 PM, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> On śro, 2015-01-07 at 18:29 +0530, Anand Moon wrote:
> > Enable CONFIG_LOCKUP_DETECTOR to validate kernel locks state for exynos SOC.
> > 
> > Enabling CONFIG_LOCKUP_DETECTOR help validator tracks the 'state' of lock-classes,
> > and it tracks dependencies between different lock-classes.
> > The validator maintains a rolling proof that the state and
> > the dependencies are correct.
> 
> Unfortunately this is not correct. Lockup detector does something else.
> Please read the help/manual for LOCKUP_DETECTOR. You can find in
> lib/Kconfig.debug (around line 667).
> 
> Best regards,
> Krzysztof
> 
> > 
> > Changes since v2:
> >  * Made commit message more clear
> >  * Corrected grammer in code comment
> > 
> > Tested on Exynos5422 ODROID XU3 board.
> > 
> > Signed-off-by: Anand Moon <moon.linux@yahoo.com>
> > Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  arch/arm/configs/exynos_defconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
> > index 5ef14de..ecd9987 100644
> > --- a/arch/arm/configs/exynos_defconfig
> > +++ b/arch/arm/configs/exynos_defconfig
> > @@ -178,6 +178,7 @@ CONFIG_PRINTK_TIME=y
> >  CONFIG_DEBUG_FS=y
> >  CONFIG_MAGIC_SYSRQ=y
> >  CONFIG_DEBUG_KERNEL=y
> > +CONFIG_LOCKUP_DETECTOR=y
> >  CONFIG_DETECT_HUNG_TASK=y
> >  CONFIG_DEBUG_RT_MUTEXES=y
> >  CONFIG_DEBUG_SPINLOCK=y

