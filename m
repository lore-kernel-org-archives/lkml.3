Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965449Ab3GLUqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:46:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965365Ab3GLUqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:46:46 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=HICIQ9bjhMYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PINbNDQYIjoA:10 a=viUFN44M_gvwnEO8oTwA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373662005.17876.127.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linux-foundation.org
Date: Fri, 12 Jul 2013 16:46:45 -0400
In-Reply-To: <20130712203334.GA24331@kroah.com>
References: <20130712005023.GB31005@thunk.org>
	 <20130712025745.GA24086@tuxdriver.com> <20130712033430.GA3798@kroah.com>
	 <51E03AEE.5010403@zytor.com> <20130712172836.GA7627@kroah.com>
	 <20130712175718.GA342@thunk.org> <51E0480A.2040905@zytor.com>
	 <51E04AB9.1000003@zytor.com>
	 <CA+55aFw0PvYBguFmacL0FC6V_hjGVcUWsrZ6HO9tuQof=yw5PA@mail.gmail.com>
	 <1373658797.17876.119.camel@gandalf.local.home>
	 <20130712203334.GA24331@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 13:33 -0700, Greg Kroah-Hartman wrote:

> That's what mailboxes are for, use a script of 'git send-email' to send
> it to yourself and save it somewhere.  Use patchwork.  Use a text file
> to remind yourself.  Use quilt, like Andrew does, he has a great track
> record of marking patches for the stable trees properly.  Use something,
> it really isn't that hard, or at least, it sure shouldn't be, if you
> really care about it.

Or use git notes locally ;-)

-- Steve


