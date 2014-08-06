Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaHFKXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:23:54 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:36689 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbaHFKXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:23:52 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of load_balance() in scheduler
References: <20140730014827.565626091@linuxfoundation.org>
	<20140730014829.344302554@linuxfoundation.org>
	<20140730065312.GA1652@laptop.redhat.com>
	<CA+55aFzr_wJzt6RpojXpDo-ashV_N7sP+j7Ba0ND9mSpr7MKRQ@mail.gmail.com>
	<CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com>
	<CA+55aFwvRcr98M=425eCR8K04X-uAVjH2bs3hudkySVKM4VqVg@mail.gmail.com>
	<CA+5PVA79a-BoMMAzryH0O3NFz6KY1f9REAmE=T00ErfcUfCGEg@mail.gmail.com>
	<20140805210728.GH13858@redhat.com>
	<CA+55aFwq72kDdRSWXKhyO1j=_PAKB960+RNOD6Cou0wZTa+5Hw@mail.gmail.com>
	<20140806081441.GZ7393@tucnak.redhat.com>
Date: Wed, 06 Aug 2014 11:23:47 +0100
In-Reply-To: <20140806081441.GZ7393@tucnak.redhat.com> (Jakub Jelinek's
	message of "Wed, 6 Aug 2014 10:14:41 +0200")
Message-ID: <yw1xfvh9532k.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Jelinek <jakub@redhat.com> writes:

> There have been several man-years of work to get from the 25% var coverage
> to 67%, several DWARF extensions (most of them to be available in DWARF5 or
> work in progress on that) and with -fno-var-tracking-assignments that is
> just returned to the old state.

This is a typical "but look at all the work we've put in, it *has* to
work" argument.  As always, it is completely without merit.

>> In other words, anybody who relies on it has already learnt to work
>> around it. Or, more likely, there just isn't anybody who relies on it.
>> 
>> I don't understand how you guys can be so cavalier about a compiler
>> bug that has already resulted in actual real problems. You bring up
>
> I have no problem with a -fno-var-tracking-assignments workaround for
> compilers that have the PR61801 wrong-code bug.

Are there any that with reasonable confidence do not?

-- 
Måns Rullgård
mans@mansr.com
