Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679Ab3E1Iyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:54:41 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:37530 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933624Ab3E1Iyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:54:40 -0400
Date: Tue, 28 May 2013 10:54:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: luto@amacapital.net, linux-kernel@vger.kernel.org, x86@kernel.org,
        trinity@vger.kernel.org
Subject: Re: [PATCH 0/5] x86: oops on uaccess faults outside of user addresses
Message-ID: <20130528085435.GC30172@gmail.com>
References: <cover.1369177867.git.luto@amacapital.net>
 <20130522.142847.791230763817666795.davem@davemloft.net>
 <20130528082514.GA29730@gmail.com>
 <20130528.015105.1513437101791265718.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528.015105.1513437101791265718.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@kernel.org>
> Date: Tue, 28 May 2013 10:25:14 +0200
> 
> > 
> > * David Miller <davem@davemloft.net> wrote:
> > 
> >> Please don't mix networking and non-networking changes into a patch
> >> series.
> > 
> > As explained in 0/5 the networking fix justifies the first 4 patches. The 
> > networking fix is independent of the first 4 patches.
> > 
> >> Submit the networking patch to netdev@vger.kernel.org
> > 
> > He Cc:-ed the patch to netdev@vger.kernel.org. If you agree with it then 
> > the fix should probably be picked up ASAP.
> 
> He submitted it as part of a series which implies that it belongs together
> with the others.

And then described it in the 0/5 patch that it's not. It's also visible 
from the title, the changelog and the diff of the 5/5 patch that it's a 
separate fix.

So please consider it submitted.

Thanks,

	Ingo
