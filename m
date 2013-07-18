Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab3GRJGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:06:06 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39156 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3GRJGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:06:02 -0400
Message-ID: <51E7AFED.20509@redhat.com>
Date: Thu, 18 Jul 2013 11:05:49 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
References: <20130715155202.GC29526@xanatos>  <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>  <20130715174659.GC15531@xanatos>  <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>  <20130715180403.GD15531@xanatos>  <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>  <20130715184642.GE15531@xanatos>  <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>  <20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos>  <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>  <1373926109.17876.221.camel@gandalf.local.home>  <CA+55aFwdYxfgE8B4oPVFXWTJUcnDKnM4cchZ=t08mFwEHX+TAA@mail.gmail.com> <1373999229.2148.87.camel@dabdike>
In-Reply-To: <1373999229.2148.87.camel@dabdike>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/07/2013 20:27, James Bottomley ha scritto:
> I'm perfectly happy to run linux-scsi along reasonable standards of
> civility and try to keep the debates technical, but that's far easier to
> do on a low traffic list; obviously, I realise that style of argument
> doesn't suit everyone, so it's not a standard of behaviour I'd like to
> see universally imposed.

Honestly, it is not just the low traffic, it's also that most of the
patches (90%?) are drivers that hardly anyone cares about.  There is
very little core work going on in linux-scsi, which would be a lot
harder to discuss and review (making heated tones more likely to
happen).  This is not what happens in other areas (net for example, just
to remain within drivers/).

> In fact, I've got to say that I wouldn't like
> to see *any* behaviour standard imposed ... they're all basically cover
> for power plays (or soon get abused as power plays); the only real way
> to display leadership on behaviour standards is by example not by fiat.

This I completely agree with, and you set a great example of civility.

Paolo
