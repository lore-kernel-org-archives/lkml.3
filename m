Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3G2O2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:28:33 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56267 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab3G2O2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:28:31 -0400
Date: Mon, 29 Jul 2013 07:28:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kevin Easton <kevin@guarana.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, davem@davemloft.net,
        arnd@arndb.de, mingo@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH jiffies] Avoid undefined behavior from signed overflow
Message-ID: <20130729142812.GN26694@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130727225828.GA11864@linux.vnet.ibm.com>
 <20130729153035.18805zox54aoyubf@chicago.guarana.org>
 <20130729135411.GM26694@linux.vnet.ibm.com>
 <20130730000103.35524r83mpydvs7z@chicago.guarana.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730000103.35524r83mpydvs7z@chicago.guarana.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072914-5806-0000-0000-00002238F929
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 12:01:03AM +1000, Kevin Easton wrote:
> Quoting "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>:
> 
> >On Mon, Jul 29, 2013 at 03:30:35PM +1000, caf@guarana.org wrote:
> >>Quoting "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>:
> >>
> ...
> >>>
> >>>Note that the C standard considers the cast from signed to
> >>>unsigned to be implementation-defined, see 6.3.1.3p3.
> ...
> >>
> >>Don't worry, the case from signed to unsigned is actually well-defined -
> >>the relevant part is 6.3.1.3p2 (in C99):
> >>
> >>>Otherwise, if the new type is unsigned, the value is converted by
> >>>repeatedly adding or subtracting one more than the maximum value that
> >>>can be represented in the new type until the value is in the range of
> >>>the new type.
> >
> >Yep, but we are going in the other direction, from unsigned to signed.
> 
> Ahh, there's an error in the commit message (it says signed to unsigned).

Good catch, fixed!

							Thanx, Paul

