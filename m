Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3GQFWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:22:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:29065 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab3GQFWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:22:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,682,1367996400"; 
   d="scan'208";a="371556628"
Date: Tue, 16 Jul 2013 22:22:50 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Rusty Russell <rusty@rustcorp.com.au>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130717052250.GB14392@xanatos>
References: <20130715155202.GC29526@xanatos>
 <20130716210856.GF4994@xanatos>
 <CA+55aFwcT3pRjKKB3c+QPVZ3tREVKJwszE5EMwJ_eQTjPkOzXQ@mail.gmail.com>
 <4384290.4rZz7uttsZ@vostro.rjw.lan>
 <CA+55aFy=XOKNePc+buJovaBu-WVUHHh=J35SSG1HyraGqH6PXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy=XOKNePc+buJovaBu-WVUHHh=J35SSG1HyraGqH6PXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 03:12:45PM -0700, Linus Torvalds wrote:
> I react very strongly when somebody argues against fixing regressions.
> Let's just say that there's too many years of baggage that I carry
> around on that issue..
> 
> So that is definitely one of the things that make me go ballistic.
> Buggy code isn't actually one of them. Bugs happen. Even really stupid
> bugs happen, and happen to good people. They had a bad day, or it was
> just a brainfart.  Not that I will be _polite_ about bad code, mind
> you, and there might be some bad words in there, but it doesn't make
> me blow up.
> 
> Being cavalier about known regressions is definitely the primary
> trigger. I suspect there are others, but I can't seem to recall any
> other particular hot-button issues right now. Maybe Sarah can post a
> few more pointers..

Hmm... The only thing I can think of off the top of my head is that you
tend to hate it when someone puts the needs of their particular
architecture or distro at a higher priority than the needs of the kernel
community.  If they start to push crap code late in the merge window to
further their personal goals, you tend to blow up at them.  See the
'deep throat' comment on the PE binary signing thread, for instance.

The timing of when incidents happen also seems to effect whether you get
triggered.  I suspect most of the incidents of you "blowing up" at
people happen during the merge window.

Sarah Sharp
