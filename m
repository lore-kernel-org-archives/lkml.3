Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaAOXVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:21:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41969 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaAOXVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:21:47 -0500
Date: Wed, 15 Jan 2014 15:21:41 -0800 (PST)
Message-Id: <20140115.152141.736966534492130155.davem@davemloft.net>
To: richard@nod.at
Cc: rl@hellgate.ch, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com
Subject: Re: [PATCH] net,via-rhine: Fix tx_timeout handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389735996-4692-1-git-send-email-richard@nod.at>
References: <1389735996-4692-1-git-send-email-richard@nod.at>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>
Date: Tue, 14 Jan 2014 22:46:36 +0100

> rhine_reset_task() misses to disable the tx scheduler upon reset,
> this can lead to a crash if work is still scheduled while we're resetting
> the tx queue.
> 
> Fixes:
> [   93.591707] BUG: unable to handle kernel NULL pointer dereference at 0000004c
> [   93.595514] IP: [<c119d10d>] rhine_napipoll+0x491/0x6
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Applied and queued up for -stable, thanks.
