Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3EOXzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 19:55:21 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60769 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab3EOXzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 19:55:18 -0400
Date: Wed, 15 May 2013 16:55:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <20130515235512.GT4442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130509125040.GF27333@pd.tnic>
 <20130509125859.GG27333@pd.tnic>
 <20130515184528.GO4442@linux.vnet.ibm.com>
 <20130515224358.GF11783@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515224358.GF11783@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051523-9360-0000-0000-00001235DF22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 12:43:58AM +0200, Borislav Petkov wrote:
> On Wed, May 15, 2013 at 11:45:28AM -0700, Paul E. McKenney wrote:
> > Does the following patch help?
> 
> Hmm, I just tried on 3.10-rc1
> 
> CONFIG_NO_HZ_FULL_ALL=y
> 
> on the one hand and then
> 
> CONFIG_NO_HZ_FULL=y
> # CONFIG_NO_HZ_FULL_ALL is not set
> 
> with "nohz_full=4-7 rcu_nocbs=4-7" on the cmdline and I don't see the
> splats anymore.
> 
> Do I need to try something else?

I never saw the problem, so I have to defer to you on this one.  I will
hold off on the patch unless the problem shows up again.

							Thanx, Paul

