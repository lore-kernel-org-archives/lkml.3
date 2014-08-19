Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaHSU4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:56:34 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50942 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaHSU4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:56:31 -0400
Date: Tue, 19 Aug 2014 13:56:27 -0700
From: Benjamin Poirier <benjamin.poirier@gmail.com>
To: Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] tg3: Fix tx_pending checks for tg3_tso_bug
Message-ID: <20140819205627.GA20702@f1.synalogic.ca>
References: <1408474371-19509-1-git-send-email-bpoirier@suse.de>
 <1408474371-19509-2-git-send-email-bpoirier@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408474371-19509-2-git-send-email-bpoirier@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/08/19 11:52, Benjamin Poirier wrote:
> +		trace_printk("stopping queue, %d <= %d\n",
> +			     tg3_tx_avail(tnapi), skb_shinfo(skb)->gso_segs);
>  		netif_tx_stop_queue(txq);
> +		trace_printk("stopped queue\n");

err, I'll resubmit without the trace_printk. Please review for other
issues nevertheless.
