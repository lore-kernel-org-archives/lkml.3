Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3EMBfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 21:35:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60035 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab3EMBf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 21:35:27 -0400
Date: Sun, 12 May 2013 18:35:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time
 as with v3.9
Message-ID: <20130513013518.GM3648@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87r4hdjsu5.fsf@nemi.mork.no>
 <20130512113157.GG3648@linux.vnet.ibm.com>
 <20130512182935.GD24440@8bytes.org>
 <20130512205747.GK3648@linux.vnet.ibm.com>
 <20130512213430.GE24440@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130512213430.GE24440@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051301-7182-0000-0000-000006A85146
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 11:34:30PM +0200, Joerg Roedel wrote:
> On Sun, May 12, 2013 at 01:57:48PM -0700, Paul E. McKenney wrote:
> > That does look pretty extreme!  If you build with CONFIG_RCU_NO_HZ=n,
> > but without the revert, do you still get the delays?
> 
> With CONFIG_RCU_NO_HZ=n (and no revert) the system boots fine, no boot
> delay. I also enabled some RCU debugging options (with
> CONFIG_RCU_NO_HZ=y), but didn't see anything so far.

OK, good -- we at least have an easy work-around while I am tracking
this down.  ;-)

							Thanx, Paul

