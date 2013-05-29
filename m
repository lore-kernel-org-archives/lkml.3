Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3E2FSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 01:18:14 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45414 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3E2FSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 01:18:13 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <201305271231.40693.arnd@arndb.de>
Date: Wed, 29 May 2013 15:18:03 +1000
Cc: Pawel Moll <pawel.moll@arm.com>, linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <146FF7AD-650E-4706-B9E1-53C2693D1D0D@gmail.com>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <201305262323.29519.arnd@arndb.de> <30BA4666-664F-4DA4-A1D5-C2B8AA63C6AB@gmail.com> <201305271231.40693.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 27/05/2013, at 8:31 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 27 May 2013, Daniel Tang wrote:
>>> The one remaining bit that sticks out is the clcd platform data. As I
>>> said before, I won't require you to convert that to DT in order to
>>> get your code merged, but I'd also really like to see that happen,
>>> as we will also need that to get rid of auxdata on the ARM reference
>>> platforms (integrator, versatile, realview, vexpress).
>> 
>> How would you like me to convert the platform data to DT? AFAIK, the clcd
>> driver isn't aware of DT so the only way is to use the AUXDATA right now.
> 
> Linus Walleij mentioned on IRC that Pawel Moll already posted a series
> that adds DT support for clcd:
> 
> http://lists.freedesktop.org/archives/dri-devel/2013-April/037519.html
> 
> The series does a few more things, but you can probbly split out the
> parts you need and base on that.

Would it be fine if I waited until CLCD DT patch gets into mainline instead?

> 
> 	Arnd

Cheers,
Daniel Tang
