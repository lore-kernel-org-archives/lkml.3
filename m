Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbaAGMYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:24:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32927 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaAGMYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:24:09 -0500
Date: Tue, 7 Jan 2014 13:24:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] Power consumption on a 2013 MBP
Message-ID: <20140107122407.GC10358@amd.pavel.ucw.cz>
References: <CALkWK0n0q+a9EmMbJXsgo6eO1B+0Lq6tqsN3moLbXz+Y0GGu0g@mail.gmail.com>
 <20140106211115.GA23421@amd.pavel.ucw.cz>
 <CALkWK0nLg9D+4=_eNe3cgmnuzzZgk+E5U_OK9vh6_3XTZSX12w@mail.gmail.com>
 <20140106213630.GC14927@amd.pavel.ucw.cz>
 <CALkWK0kFRS2ZhsNdmBLms-XzpJ-5mc+--NFhx-tM==H2qrfXmQ@mail.gmail.com>
 <CALkWK0=uTF_SakQ1oR-wv3T26wJbGWwPkkXKmCpF1O_X59T55A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0=uTF_SakQ1oR-wv3T26wJbGWwPkkXKmCpF1O_X59T55A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-01-07 16:03:00, Ramkumar Ramachandra wrote:
> Ramkumar Ramachandra wrote:
> > My system freezes if I remove modules like usbhci, ahci, ehci_hcd.
> 
> Correction: my input devices (keyboard, trackpad) depend on usbhci,
> ehci_hcd, while libata and my hard disk drivers depend on ahci;
> there's no way I can do without them. 

Ramdisk, scripts.

>I'm trying to get VGA switcheroo
> to work so I can switch to the onboard i915 graphics card in the hope
> of saving power.

That should indeed do the trick.x
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
