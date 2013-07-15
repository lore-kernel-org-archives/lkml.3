Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab3GOTE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:04:26 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65220 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3GOTEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:04:24 -0400
Date: Mon, 15 Jul 2013 14:04:19 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [ 00/19] 3.10.1-stable review
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
In-Reply-To: <20130715155202.GC29526@xanatos> (from
	sarah.a.sharp@linux.intel.com on Mon Jul 15 10:52:48 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1373915059.3719.4@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 10:52:48 AM, Sarah Sharp wrote:
> On Fri, 12 Jul 2013 18:17:08 +0200, Ingo Molnar <mingo@kernel.org>  
> wrote:
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Let's discuss this at Kernel Summit where we can at least yell at each
> other in person.  Yeah, just try yelling at me about this.  I'll roar
> right back, louder, for all the people who lose their voice when they
> get yelled at by top maintainers.  I won't be the nice girl anymore.

Not _all_ of us lose our voice when yelled at by Linus's lieutenants.  
Some of us just post updates to the same darn patch series for 5 years  
(yes really; my perl removal series started in 2008 and was applied  
earlier this year), on the theory it's useful to the people actually  
applying it to their own trees (at one point, gentoo), and that someday  
the stars might be right and cthulu will arise from the deep and accept  
the patch series into his tree. (Or in my case, Andrew Morton.)

Hoping initmpfs has an easier time of it, it's already being used in  
supercomputers.

Rob