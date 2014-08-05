Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaHELqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:46:54 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:56448 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbaHELqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:46:52 -0400
Date: Tue, 5 Aug 2014 13:46:49 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of
 load_balance() in scheduler
Message-ID: <20140805114649.GA295@x4>
References: <20140730014827.565626091@linuxfoundation.org>
 <20140730014829.344302554@linuxfoundation.org>
 <20140730065312.GA1652@laptop.redhat.com>
 <CA+55aFzr_wJzt6RpojXpDo-ashV_N7sP+j7Ba0ND9mSpr7MKRQ@mail.gmail.com>
 <CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.08.05 at 07:31 -0400, Josh Boyer wrote:
> Sorry to bring this back up after the fact, but it's important for a
> number of things in various distros.  I don't disagree it should be
> disabled by default, but making it unconditional is going to force the
> distributions that care about perf, systemtap, and debuggers to
> manually revert this.  That deviation is concerning because the
> upstream kernel won't easily be buildable the same way distros build
> it.
> 
> I'm happy to come up with a config option patch, but I'm not sure if
> it would be accepted.  Is that a possibility at this point?

Please note that https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61923
isn't fixed yet. So it would be premature to manually revert Linus'
patch yet. 

When PR61923 gets fixed (and backported) its testcase could be combined
with the testcase Jakub posted earlier in this thread.

-- 
Markus
