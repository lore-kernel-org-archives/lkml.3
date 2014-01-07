Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaAGPkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:40:24 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37100 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaAGPkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:40:10 -0500
MIME-Version: 1.0
In-Reply-To: <20140105222346.GA25152@amd.pavel.ucw.cz>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>
	<20131230162158.7420e811@alan.etchedpixels.co.uk>
	<BLU172-W451DF59115DB2B0A7F694AACC90@phx.gbl>
	<20140101201053.12be7d27@alan.etchedpixels.co.uk>
	<alpine.DEB.2.02.1401011423180.27645@nftneq.ynat.uz>
	<20140101230135.48f6f781@alan.etchedpixels.co.uk>
	<alpine.DEB.2.02.1401011547340.27645@nftneq.ynat.uz>
	<CAK5ve-KTQvJeLXmJt-NgPy6Ju+kBzWVoSQB7TKR9TW+mfD=bxg@mail.gmail.com>
	<20140103152313.4fd5c48f@alan.etchedpixels.co.uk>
	<20140105222346.GA25152@amd.pavel.ucw.cz>
Date: Tue, 7 Jan 2014 16:40:06 +0100
Message-ID: <CACRpkdZT+fd0nZmzqwO+PVZWG_4M4Fas1SqG9CRAho6LwSAFgQ@mail.gmail.com>
Subject: Re: n900 led compiler (was Re: [PATCH] Add LED pattern trigger)
From: Linus Walleij <linus.walleij@linaro.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@ring0.de>, "Kim, Milo" <milo.kim@ti.com>,
        Bryan Wu <cooloney@gmail.com>, David Lang <david@lang.hm>,
        Joe Xue <lgxue@hotmail.com>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 5, 2014 at 11:23 PM, Pavel Machek <pavel@ucw.cz> wrote:

> I implemented compiler for it (should we put it into tools/ somewhere?)

We have a precedent for putting firmware compilers into the kernel
tree:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/aic7xxx/aicasm

But that one used FLEX. And I think the assumption is that then
you store the firmware source with the driver, and the sysfs (or similar)
interface would just load and trigger one of the pre-defined firmware
programs, not have it be sent in from userspace.

Yours,
Linus Walleij
