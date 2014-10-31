Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbaJaRKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:10:39 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:52991 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaJaRKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:10:38 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Fri, 31 Oct 2014 13:10:36 -0400
To: Heiko Schocher <hs@denx.de>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        mugunthanvnm@ti.com, netdev@vger.kernel.org
Subject: Re: Mistake in commit 0d961b3b52f566f823070ce2366511a7f64b928c
 breaks cpsw non dual_emac mode.
Message-ID: <20141031171035.GI24110@csclub.uwaterloo.ca>
References: <20141028170242.GA24112@csclub.uwaterloo.ca>
 <20141030.154323.1702996635200338108.davem@davemloft.net>
 <545330EA.60303@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545330EA.60303@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 07:49:14AM +0100, Heiko Schocher wrote:
> Seems I missed your original patch ... looked in it here:
> 
> https://lkml.org/lkml/2014/10/28/837
> 
> and I think you are correct, thanks for this fix. You can add my
> Acked-by: Heiko Schocher <hs@denx.de>
> if you post a corrected v2, as David suggested.

Will do.  I noticed a wrong word in one of the messages too so good
thing it gets fixed before getting commited.

-- 
Len Sorensen
