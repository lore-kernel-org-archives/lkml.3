Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3AVNEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:04:39 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:59362 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3AVNEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:04:38 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130122094708.GA10038@type.bordeaux.inria.fr>
References: <20110914232717.GA5410@type.famille.thibault.fr>
	<yunobym743b.fsf@aiko.keithp.com>
	<20110915074106.GA4544@type.famille.thibault.fr>
	<20110915081259.GB4877@type.bordeaux.inria.fr>
	<yunlitp7umf.fsf@aiko.keithp.com>
	<20110916163050.GT4891@type.bordeaux.inria.fr>
	<20120105021646.GA4099@type.famille.thibault.fr>
	<20120105095301.GA4504@type.bordeaux.inria.fr>
	<20130122094708.GA10038@type.bordeaux.inria.fr>
Date: Tue, 22 Jan 2013 14:04:36 +0100
X-Google-Sender-Auth: stAhcfcItWKZ8aRjyMGhWnQgj-A
Message-ID: <CAKMK7uHvuFMsbS-sKgFRPRcOXdxT2cUbx+fg-+WmEqAXv2ZpKA@mail.gmail.com>
Subject: Re: [REGRESSION FIXED] i915 KMS dual head broken on DELL latitude
 E6420 in 3.1-rc*
From: Daniel Vetter <daniel@ffwll.ch>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:47 AM, Samuel Thibault
<samuel.thibault@ens-lyon.org> wrote:
> Hello,
>
> Samuel Thibault, le Thu 05 Jan 2012 10:53:01 +0100, a écrit :
>> Samuel Thibault, le Thu 05 Jan 2012 03:16:46 +0100, a écrit :
>> > Samuel Thibault, le Fri 16 Sep 2011 18:30:50 +0200, a écrit :
>> > > Keith Packard, le Thu 15 Sep 2011 09:22:48 -0500, a écrit :
>> > > > On Thu, 15 Sep 2011 10:12:59 +0200, Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
>> > > >
>> > > > > At home only. At work, with a different VGA screen, I'm still getting
>> > > > > the issue.
>> > > >
>> > > > You're still having a problem with the LVDS screen at work with FBC
>> > > > disabled?
>> > >
>> > > Yes, though it now seems random, sometimes it works, sometimes not.
>> >
>> > I have just tried a fresh 3.2 once, without problem. Within a few days,
>> > I'll know whether it's luck or magical-fixup.
>>
>> It didn't take long. I'm still randomly getting the issue.

My apologies for losing track of your issue here, this shouldn't
happen. Please yell at us louder next time around.

> I have tried 3.7, I don't have the issue any more (tested for a month
> now). Perhaps it was already fixed in 3.6, but not much before.

3.7 seems likely, since we've fixed quite a few long-standing
lingering issues with the modeset rework merged into that version.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
