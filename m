Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3ELVed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 17:34:33 -0400
Received: from 8bytes.org ([85.214.48.195]:49208 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab3ELVec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 17:34:32 -0400
Date: Sun, 12 May 2013 23:34:30 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time
 as with v3.9
Message-ID: <20130512213430.GE24440@8bytes.org>
References: <87r4hdjsu5.fsf@nemi.mork.no>
 <20130512113157.GG3648@linux.vnet.ibm.com>
 <20130512182935.GD24440@8bytes.org>
 <20130512205747.GK3648@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130512205747.GK3648@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun May 12 23:34:31 2013
X-DSPAM-Confidence: 0.9961
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51900ae723672227717730
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 01:57:48PM -0700, Paul E. McKenney wrote:
> That does look pretty extreme!  If you build with CONFIG_RCU_NO_HZ=n,
> but without the revert, do you still get the delays?

With CONFIG_RCU_NO_HZ=n (and no revert) the system boots fine, no boot
delay. I also enabled some RCU debugging options (with
CONFIG_RCU_NO_HZ=y), but didn't see anything so far.


	Joerg


