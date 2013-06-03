Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab3FCNUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:20:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3FCNUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:20:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC] dw_apb_timer_of: use clocksource_of_init
Date: Mon, 03 Jun 2013 15:20:49 +0200
Message-ID: <2776800.oNsvP2SGCJ@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <201306031415.29411.heiko@sntech.de>
References: <201306030055.15413.heiko@sntech.de> <1822564.TIKVDZSzqK@wuerfel> <201306031415.29411.heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:MkybEPSxmvkvzRNJLerfP1mCOiLb5I+4mUU5uy/68u9
 +GbOPsGi9/lT23brv/nXz330IsMQb8TWSsY/Vd/QRH5VXtR5P+
 5ocVgRWTfFLWLPJOf1y/WpRX+ps6vjT06Ph0o0cEpYu3VCCBva
 CDeDRH7HsBqtc6XE2QsdCjSExdabaAgaRjxsDyz0O0UdGtqO1e
 HTiUoe1ETVRHj7/JzC8W1v2JNbDSUpgbscwTJckVK2h/Z1k9vv
 zudGM+UMMLtmuoEm8rESKX5QaZBe1f98RdQ4QDZsZY0wwO3qzF
 xh6zV6kS4YEF/oFnepqG6+/ny6D/vtLMnpurRnw3RgK03XXzQD
 qePoQOySGt/h6zoiebRI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013 14:15:28 Heiko Stübner wrote:
> dw_apb_timer_init used to search the devicetree for matching timer
> devices, making calls to it from board files necessary.
> 
> Change the dw_apb_timer_init to work with CLOCKSOURCE_OF_DECLARE.
> With this change the function gets called once for each timer node
> and tracks these number of calls to attach clockevent and clocksource
> devices to the nodes.
> 
> Also convert all previous users of dw_apb_timer_init to use
> clocksource_of_init.
> 
> Tested on the upcoming rk3066 code.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
