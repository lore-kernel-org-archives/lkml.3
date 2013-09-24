Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3IXQWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:22:47 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:42762 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3IXQWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:22:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130923181707.GR2779@lukather>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
	<1379852488-32147-2-git-send-email-cinifr@gmail.com>
	<20130923181707.GR2779@lukather>
Date: Wed, 25 Sep 2013 00:22:44 +0800
Message-ID: <CAK3cCBwLrnV7L9WzJ+1P_62PEjEEtgzVjFH8m6SZzWG1O+2vEw@mail.gmail.com>
Subject: Re: [PATCH V3: Add Smp support for Allwinner A20. 1/3] Add smp
 support for Allwinner A20(sunxi 7i).
From: cinifr <cinifr@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: coosty@163.com, Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Please use sun7i here as well.
>
Ok, it will be modified by next patch.

>> +early_initcall(sunxi_init_cpuconfig_map);
>
> You still haven't said why you don't want to use smp_init_cpus there.
I find that of_funcation liking of_find_matching_node and of_iomap can
not run well in smp_init_cpus. It cause kernel crash. So I have to use
early_initcall.

Fan
