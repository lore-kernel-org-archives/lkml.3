Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3HDUeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 16:34:23 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33583 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab3HDUeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 16:34:22 -0400
Date: Sun, 4 Aug 2013 13:34:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Easton <kevin@guarana.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH jiffies] Avoid undefined behavior from signed overflow
Message-ID: <20130804203415.GR3836@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130727225828.GA11864@linux.vnet.ibm.com>
 <20130729153035.18805zox54aoyubf@chicago.guarana.org>
 <20130729135411.GM26694@linux.vnet.ibm.com>
 <20130730000103.35524r83mpydvs7z@chicago.guarana.org>
 <20130729142812.GN26694@linux.vnet.ibm.com>
 <CA+55aFxOp-uNHQydWfa90H+DCDvZK6d2N0fGgSNkHNrLuYWMLA@mail.gmail.com>
 <20130804202050.GP3836@linux.vnet.ibm.com>
 <CA+55aFz2mLabJTjKffYcJfWycseNUS5F=vEzmorL7QZn7SnxLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz2mLabJTjKffYcJfWycseNUS5F=vEzmorL7QZn7SnxLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080420-7408-0000-0000-000012A773D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 04, 2013 at 01:23:13PM -0700, Linus Torvalds wrote:
> On Sun, Aug 4, 2013 at 1:20 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > I have it queued up for 3.12, as you say, due to "-fno-strict-overflow".
> > But if you would rather have it sooner, please let me know and I will send
> > a pull request.
> 
> No, that's fine. As long as it's somewhere. 3.12 is better, rc4 is
> already getting too big for my taste.

3.12 it is, then!

							Thanx, Paul

