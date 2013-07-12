Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384Ab3GLUJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:09:22 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:53033 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965197Ab3GLUJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <1373658797.17876.119.camel@gandalf.local.home>
References: <20130711214830.611455274@linuxfoundation.org>
	<20130712005023.GB31005@thunk.org>
	<20130712025745.GA24086@tuxdriver.com>
	<20130712033430.GA3798@kroah.com>
	<51E03AEE.5010403@zytor.com>
	<20130712172836.GA7627@kroah.com>
	<20130712175718.GA342@thunk.org>
	<51E0480A.2040905@zytor.com>
	<51E04AB9.1000003@zytor.com>
	<CA+55aFw0PvYBguFmacL0FC6V_hjGVcUWsrZ6HO9tuQof=yw5PA@mail.gmail.com>
	<1373658797.17876.119.camel@gandalf.local.home>
Date: Fri, 12 Jul 2013 14:09:19 -0600
Message-ID: <CAKocOONZ4LDq45nNVcyDT1b7RfwQdDr2YpVct7PT2-Qe5hWtVw@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: Shuah Khan <shuahkhan@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 1:53 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2013-07-12 at 12:44 -0700, Linus Torvalds wrote:
>
>> They can be useful for "local" notes (they can be very powerful for
>> certain workflows), but they won't be pulled and pushed by me.
>
> Perhaps notes can be used as that reminder to send to stable. Tag a
> commit with a note, and have some automated process that monitors
> Linus's tree and when a commit makes it in, automate an email to stable
> with said commit.
>
> -- Steve

Including quick sanity tests to see if these patches apply cleanly to
stable releases in this automation process will help weed out patches
that don't apply as is to stable releases.

-- Shuah
