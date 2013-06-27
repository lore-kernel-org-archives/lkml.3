Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3F0NQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:16:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab3F0NQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:16:50 -0400
Date: Thu, 27 Jun 2013 15:16:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, rtitmuss@logitech.com,
        ogay@logitech.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Jean-Daniel Zanone <jzanone@logitech.com>,
        =?ISO-8859-15?Q?Franti=A8ek_Fuka?= <fuka@fuxoft.cz>
Subject: Logitech M705: Thumb button (was Re: [PATCH v4] HID: Add full support
 for Logitech Unifying receivers)
In-Reply-To: <CAN+gG=E90-y--6C-Ok8TibcFZGAaL2X-KxnchquDLCUUniip1Q@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1306271513180.3538@pobox.suse.cz>
References: <1315638713-3731-1-git-send-email-benjamin.tissoires@gmail.com> <20110910072826.GA1611@x4.trippels.de> <CAN+gG=H2jfT2zdn5H19hyn9JtDU7U1ensX_aUDgv0jk4d81jXg@mail.gmail.com> <CAN+gG=E90-y--6C-Ok8TibcFZGAaL2X-KxnchquDLCUUniip1Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Frantisek Fuka added to CC ]

On Wed, 14 Sep 2011, Benjamin Tissoires wrote:

> >> Nice. Does this mean I will be able to use the thumb-button of my M705
> >> mouse in the near future?
> >>
> >> (Someone asked the same question 1.5 years ago, but nothing happened 
> >> till then: http://thread.gmane.org/gmane.linux.kernel.input/11791 )
> >
> > This is quite weird. I was going to say that it will work, but with
> > the M705 I've got at home,this thumb button doesn't work at all
> > (anything is emitted from the usb, even with this driver).
> > But I'm pretty sure I made it work with the one I got at work.
> >
> > I'll give a try on Monday unless people at Logitech gave us the solution.

> I got some information for you. Apparently, it won't be possible to
> enable this thumb button right now.
> To enable it, the Windows driver put the mouse in a kind of debug mode
> that need to be handled properly, which is not the case as of today.
> 
> I was able to make it work at home because there were different series
> of M705, the latest sending the thumb button by default.

Let me resurrect this 2 years old thread, as I have received multiple 
reports since then, stating that some revisions of M705 don't have working 
thumb button.

Question mostly to the Logitech guys: Nestor, Olivier, could you please 
provide us with the sequence that needs to be sent to (certain revisisons 
of) M705 to let enter the debug mode, making the thumb button actually 
emit a USB message?

Thanks,

-- 
Jiri Kosina
SUSE Labs
