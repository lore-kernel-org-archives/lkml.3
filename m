Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3GQNet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:34:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:57418 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3GQNer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:34:47 -0400
Message-ID: <51E69D50.10000@windriver.com>
Date: Wed, 17 Jul 2013 09:34:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Rob Landley <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Documentation: update references to v2.6.x in development-process
References: <1373931284-26333-1-git-send-email-paul.gortmaker@windriver.com> <20130716113349.274da843@lwn.net>
In-Reply-To: <20130716113349.274da843@lwn.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-07-16 01:33 PM, Jonathan Corbet wrote:
> On Mon, 15 Jul 2013 19:34:44 -0400
> Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
>> The last mainline release of a v2.6.x kernel was back in May 2011.
>> Here we update references to be 3.x based, which also means updating
>> some dates and statistics.
> 
> Ccing the author of the document never hurts :)

It might be worth sticking an entry in MAINTAINERS for that dir.
If one had asked me who wrote it, I probably would have recalled that
info, but instead I just out of habit ran get_maintainers...

> 
> I actually went through this exercise a while back, but somehow never got
> around to sending the changes out into the world.  Easily distracted, I
> guess.  Anyway, you can put my Acked-by on your changes if you like.

Thanks.

> 
>> On a similar note, I was thinking about the recent thread on linux-next
>> where we were indicating that people shouldn't rebase linux-next content
>> on a whim, and that new devel (vs. bugfix) content shouldn't appear in
>> the linux-next content during the merge window.  There is no question
>> that the linux-next process is integral to the main flow of patches to
>> mainline, so I think Documentation/development-process/2.Process (the
>> same file) should also capture those points in the linux-next section.
>> Do you have some pre-canned text we can insert there, or should I draft
>> something up for you to review?
> 
> Seems useful, I could also try to help with this if you run out of steam.
> I'd be more inclined to put it into section 7, though, since it's the sort
> of thing early-stage developers don't normally need to worry about.

I'd agree with that; a pointer in section two where linux-next is 1st
mentioned can point to section7 where the advanced info is given.  

Paul.
--

> 
> Thanks,
> 
> jon
> 
