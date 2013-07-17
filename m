Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3GQHrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:47:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46003 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3GQHre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:47:34 -0400
Date: Wed, 17 Jul 2013 10:46:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML (was: [
 00/19] 3.10.1-stable review)
Message-ID: <20130717074644.GA5585@mwanda>
References: <20130715180403.GD15531@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
 <20130715204135.GH15531@xanatos>
 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
 <1373926109.17876.221.camel@gandalf.local.home>
 <20130715223615.GI15531@xanatos>
 <20130715231555.GA24650@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715231555.GA24650@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 04:15:55PM -0700, Guenter Roeck wrote:
> "Your code breaks the build for every platform. Would you please kindly
> consider fixing it ?"

Something like this: https://lists.launchpad.net/ac100/msg01040.html

"small typo here."

Marc, was obviously dripping with sarcasm when he wrote that, but it
was completely lost on the patch submitter.  I've done that too
where I asked "Are you sure you want to call schedule() while
holding a spinlock()?"  It ended up becoming flame fest and it could
have been avoided if I had said, "You are not allowed to call
shedule() while holding a spinlock."

Also instead of saying "Your code is crap", I prefer to say "This
patch is crap."  I suspect the submitters secretly know I think they
are crap too along with their code, but it's important to maintain
the facade.  :)

One other thing which is tricky is if there is someone whose patches
are so worthless it's just a waste of time.  There have been a
couple times where I've told people to stop submitting patches until
they have a few more years of programming experience.

regards,
dan carpenter

