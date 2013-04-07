Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934366Ab3DGVG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 17:06:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58464 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934308Ab3DGVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 17:06:57 -0400
Date: Sun, 07 Apr 2013 17:06:54 -0400 (EDT)
Message-Id: <20130407.170654.613017631446034661.davem@davemloft.net>
To: alan@signal11.us
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] 802.15.4 and 6LoWPAN Buffering Fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364997658-16498-1-git-send-email-alan@signal11.us>
References: <1364928481-1813-1-git-send-email-alan@signal11.us>
	<1364997658-16498-1-git-send-email-alan@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 07 Apr 2013 14:06:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Wed,  3 Apr 2013 10:00:54 -0400

> Version 2 of this patch series:
> 
> Differences from v1:
> 
> 1. Patches previously numbered 5 and 6 were squashed (to become current
> patch #4) at the request of Alexander Smirnov.
> 
> 2. Current patch #2 had extraneous braces removed.
> 
> 3. Current patch #1 was changed. It is now a patch to make mac802154 _not_
> retry sending packets on failure. I believe this to be consistent with the
> 802.15.4 specification (Section 7.5.6.4.3 of IEEE 802.15.4-2006)

Series applied, thanks.
