Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3KEJwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:52:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab3KEJwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:52:16 -0500
Date: Tue, 5 Nov 2013 10:52:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Nikolai Kondrashov <spbnick@gmail.com>
Cc: AceLan Kao <acelan.kao@canonical.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, Kevin Fenzi <kevin@scrye.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: ELAN Touchscreen regression in recent 3.12 rc's? (USB)
In-Reply-To: <5270C549.30201@gmail.com>
Message-ID: <alpine.LNX.2.00.1311051051590.2779@pobox.suse.cz>
References: <20131028150250.755b4cc8@voldemort.scrye.com> <CA+5PVA5hB9CcoxqWPvF1uJymKMtfyGJv9Tkkh8bxOdAmM-jKkQ@mail.gmail.com> <CAFv23QmGeGMCVAJCQHv8oDk_ZrXHKsemP1MHnn+uaQQ5DKoFOA@mail.gmail.com> <5270C549.30201@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013, Nikolai Kondrashov wrote:

> > It's hard to believe that those quirks will lead to the problem.
> > And actually, there are 4 new commits introduced to -rc7, and 3 of
> > them are quirks.
> > 
> > % git log --pretty=oneline v3.12-rc6..v3.12-rc7 drivers/hid
> > 86b84167d4e67372376a57ea9955c5d53dae232f HID: wiimote: add LEGO-wiimote VID
> > ad0e669b922c7790182cf19f8015b30e23ad9499 HID: Fix unit exponent parsing
> > again
> > 684524d35fe8d13be1f2649633e43bd02c96c695 HID: usbhid: quirk for SiS
> > Touchscreen
> > 8171a67d587a09e14a4949a81e070345fedcf410 HID: usbhid: quirk for
> > Synaptics Large Touchccreen
> > 
> > CC'd Nikolai, since his commit changes the protocol.
> 
> My change is very unlikely to produce such problems. It changes calculation of
> axes resolution at the time the report descriptor is processed. The results of
> the calculation are not used by the kernel, AFAIK, but only by userspace
> drivers. The results should not be used to affect the interactions with the
> device, but only the interpretation of the reports (again, in userspace), and
> even that is barely done currently.
> 
> Please try reverting that particular commit and see if it affects the
> behavior.

AceLan,

do you have any update, please?

-- 
Jiri Kosina
SUSE Labs
