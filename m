Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbbAORNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:13:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:55750 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751658AbbAORNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:13:08 -0500
Date: Thu, 15 Jan 2015 18:13:06 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3 5/8] ARM: at91: move the restart function to the
 system timer driver
Message-ID: <20150115171306.GW3843@piout.net>
References: <1421077023-30954-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421077023-30954-6-git-send-email-alexandre.belloni@free-electrons.com>
 <54B7ED29.9060700@linaro.org>
 <20150115170134.GU3843@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115170134.GU3843@piout.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/2015 at 18:01:34 +0100, Alexandre Belloni wrote :
> > Mmh, I can't clearly explain why but I have a problem with that.
> > 
> > Can you explain why restart code falls in the clockevents driver ?
> > 
> > 
> 
> That is a temporary location before getting rid of it by writing a
> proper reset driver that will use the same syscon.
> 
> The main goal is to remove mach/at91_st.h and direct accesses to the
> system timer registers.
> 

Just to add that it was not because of laziness but to avoid a
depending on an other subsystem...

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
