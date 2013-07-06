Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3GFU2j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 16:28:39 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52470 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3GFU2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 16:28:36 -0400
Message-ID: <51D87E04.3060704@googlemail.com>
Date: Sat, 06 Jul 2013 22:28:52 +0200
From: Ulrich Prinz <ulrich.prinz@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        John Stultz <john.stultz@linaro.org>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 9/9] clocksource: dw_apb_timer: special variant for rockchip
 rk3188 timers
References: <201307060051.09716.heiko@sntech.de> <201307060056.29370.heiko@sntech.de> <alpine.DEB.2.02.1307060153110.32106@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307060153110.32106@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, ok...

I got the message. With modifying the existing driver to support more
function pointers in its system struct and assigning them at the
beginning, and using them on runtime, these quirks are obsolete.

Again, this is the first time I provide code to the kernel officially
and I learned from others that I should try it by modifying not too much
code if not needed.

Adding more function pointers to a system relevant structure, doubling
the number of functions and such didn't look non-invasive to me.

But, I totally agree with your argumentation and I even wanted to do it
in the way you explained in your replies. Just the courage was missing I
guess :)

Regards,
	Ulrich
