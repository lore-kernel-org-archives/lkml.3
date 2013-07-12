Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3GLWRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 18:17:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41658 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391Ab3GLWRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 18:17:45 -0400
Message-ID: <51E08076.6040506@zytor.com>
Date: Fri, 12 Jul 2013 15:17:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
References: <20130711214830.611455274@linuxfoundation.org>  <20130712005023.GB31005@thunk.org> <20130712025745.GA24086@tuxdriver.com>  <20130712033430.GA3798@kroah.com> <51E03AEE.5010403@zytor.com>  <20130712172836.GA7627@kroah.com> <20130712175718.GA342@thunk.org>  <51E0480A.2040905@zytor.com> <51E04AB9.1000003@zytor.com>  <CA+55aFw0PvYBguFmacL0FC6V_hjGVcUWsrZ6HO9tuQof=yw5PA@mail.gmail.com> <1373658797.17876.119.camel@gandalf.local.home>
In-Reply-To: <1373658797.17876.119.camel@gandalf.local.home>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 12:53 PM, Steven Rostedt wrote:
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

Didn't Linus just say he won't do that?

Either way it would seem to fail to accomplish the record-keeping aspect.

	-hpa


