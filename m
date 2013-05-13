Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab3EMGAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:00:05 -0400
Received: from 8bytes.org ([85.214.48.195]:49435 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab3EMGAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:00:03 -0400
Date: Mon, 13 May 2013 08:00:01 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time
 as with v3.9
Message-ID: <20130513060001.GF24440@8bytes.org>
References: <87r4hdjsu5.fsf@nemi.mork.no>
 <20130512113157.GG3648@linux.vnet.ibm.com>
 <20130512182935.GD24440@8bytes.org>
 <20130512205747.GK3648@linux.vnet.ibm.com>
 <20130512213430.GE24440@8bytes.org>
 <20130513013518.GM3648@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513013518.GM3648@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon May 13 08:00:02 2013
X-DSPAM-Confidence: 0.9969
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5190816223675067813459
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 06:35:18PM -0700, Paul E. McKenney wrote:
> On Sun, May 12, 2013 at 11:34:30PM +0200, Joerg Roedel wrote:
> > With CONFIG_RCU_NO_HZ=n (and no revert) the system boots fine, no boot
> > delay. I also enabled some RCU debugging options (with
> > CONFIG_RCU_NO_HZ=y), but didn't see anything so far.
> 
> OK, good -- we at least have an easy work-around while I am tracking
> this down.  ;-)

Fine. Let me know if I can help you with some further testing or trying
a fix :)


	Joerg


