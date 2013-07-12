Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab3GLWUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 18:20:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41690 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757641Ab3GLWUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 18:20:16 -0400
Message-ID: <51E0810C.6060208@zytor.com>
Date: Fri, 12 Jul 2013 15:19:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
References: <20130712005023.GB31005@thunk.org> <20130712025745.GA24086@tuxdriver.com> <20130712033430.GA3798@kroah.com> <51E03AEE.5010403@zytor.com> <20130712172836.GA7627@kroah.com> <20130712175718.GA342@thunk.org> <51E0480A.2040905@zytor.com> <51E04AB9.1000003@zytor.com> <CA+55aFw0PvYBguFmacL0FC6V_hjGVcUWsrZ6HO9tuQof=yw5PA@mail.gmail.com> <1373658797.17876.119.camel@gandalf.local.home> <20130712203334.GA24331@kroah.com>
In-Reply-To: <20130712203334.GA24331@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 01:33 PM, Greg Kroah-Hartman wrote:
> 
> Is it _really_ all that hard to remember what to mark for stable
> inclusion?  If you figure it out after you have committed the patch,
> then just put a copy of it somewhere to remind yourself.  That seems to
> be what both David and I do with no problems, and I think we both deal
> with more individual patches and developers than probably most everyone
> else combined.
> 

For the record, my main reason for wanting something like git notes is
that it is now X years after a patch, the maintainer is gone, and
tracking down someone who knows about the patch is really valuable.
Someone acking a patch after the fact is someone who looked at it "back
then", and can be tracked.

Yes, you can find this in mailing list archives and so on, but we have
had problems with such extrinsic information not being as sticky as we'd
like.

	-hpa


