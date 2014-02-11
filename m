Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbaBKTbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:31:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63597 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaBKTbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:31:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pawel Moll <pawel.moll@arm.com>, arm@kernel.org,
        linux-kernel@vger.kernel.org, Alexandre Courbot <gnurou@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, lm-sensors@lm-sensors.org,
        Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>, Jean Delvare <jdelvare@suse.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 00/12] Versatile Express updates
Date: Tue, 11 Feb 2014 20:28:55 +0100
Message-ID: <2782419.lfJiZZjaFg@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6xuYg1P4fKQ6B+Pn4gzvpdhoNIlxxJeT0F765bGn9Rz
 lXyXtfIlGXyQYzzhnPeadGIIQhfNWAWcPbcu9S3s+6nNzxeVSd
 oaU55UMeEi450ToUXyvPy3RBXgwcorry9hC798zh+5zLJCDSl2
 Hd0BcoAt2qP9nE5u9gA3OBkq0psS8Ol+2KFwIeMO4RjpBKzX39
 W0ujt2ldEc5uQwPJ/5G4SxcEjyyzacZvUFMiHikmyToT8bZ7wl
 niXf2IPmSu2CYYmsSgPYouXOJonqTw9zQ6dbfiLZ0OEEx3BC6V
 ns6uWHM7KI3QqtCaGZna7rRjbUGqJqSmnm1HMFD6zw4AbP4vb2
 2YZJ65fDOGSc1RqEp4Og=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 February 2014 17:10:24 Pawel Moll wrote:
> This series is a set of updates following the infrastructure
> rework and depends on it. It will be finally posted once
> the main series is merged. For the time being I would really
> appreciate feedback and/or (n)acks...
> 

I haven't read the patches yet, but on a general level, do
you think this code can be (or should) be shared with
mach-versatile and mach-realview?

One of the things on my (mid-term) to-do list is to completely
convert those two platforms over to being entirely DT based
and having no board specific code so we can actually delete
the directories along with mach-vexpress. The sysreg part
seems to be almost identical, and I wonder if you have an
overview of what the difference is, if any.

If we are going to share that code, we might want to give it
a different name, as vexpress is just the latest platform
in that line.

	Arnd
