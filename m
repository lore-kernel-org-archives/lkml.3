Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3GIUld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 16:41:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab3GIUlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 16:41:19 -0400
Date: Tue, 9 Jul 2013 22:41:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Richard Titmuss <rtitmuss@logitech.com>,
        Olivier Gay <ogay@logitech.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Daniel Zanone <jzanone@logitech.com>,
        =?ISO-8859-15?Q?Franti=A8ek_Fuka?= <fuka@fuxoft.cz>
Subject: Re: Logitech M705: Thumb button (was Re: [PATCH v4] HID: Add full
 support for Logitech Unifying receivers)
In-Reply-To: <CAN+gG=HNSzg_W-26vMb2seWNU+QcO3+wv4Z1AmZ36LqPhbzdEg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1307092236140.26857@pobox.suse.cz>
References: <1315638713-3731-1-git-send-email-benjamin.tissoires@gmail.com> <20110910072826.GA1611@x4.trippels.de> <CAN+gG=H2jfT2zdn5H19hyn9JtDU7U1ensX_aUDgv0jk4d81jXg@mail.gmail.com> <CAN+gG=E90-y--6C-Ok8TibcFZGAaL2X-KxnchquDLCUUniip1Q@mail.gmail.com>
 <alpine.LNX.2.00.1306271513180.3538@pobox.suse.cz> <CAE7qMrosUkhF3Yak11Mh81NcGhYduUKRoHiUwH4RbTN1KXqi8A@mail.gmail.com> <CAN+gG=HNSzg_W-26vMb2seWNU+QcO3+wv4Z1AmZ36LqPhbzdEg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jul 2013, Benjamin Tissoires wrote:

> For those who wants to try, I have set up a project [1] to implement 
> part of the spec Nestor released. I implemented various features: list 
> devices paired to a receiver, pair/unpair a device, and toggle the 
> button 6 on M705 mouse with the faulty firmware. When switching mode for 
> the M705, as Nestor said, we lose the AC panning ability until the 
> correct remapping is done in the kernel.
> 
> Cheers,
> Benjamin
> 
> [1] https://github.com/bentiss/uLogitech

Thanks for your work on this, Benjamin.

I have a followup question -- why not do this in the kernel completely 
though? I have actually been asked by Linus directly (so we'd rather do 
that :) ) to include pairing trigger as a sysfs toggle instead of having 
to use userspace utilitites, and it actually makes sense to me.

Are you aware of any particular reason to not have all that's provided by 
uLogitech in the kernel?

Thanks,

-- 
Jiri Kosina
SUSE Labs
