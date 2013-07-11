Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3GKAnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:43:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47542 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3GKAnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:43:40 -0400
Date: Wed, 10 Jul 2013 17:43:39 -0700 (PDT)
Message-Id: <20130710.174339.1202620552412048634.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: add a new chip for RTL8411
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130709230015.GA6843@electric-eye.fr.zoreil.com>
References: <1373274541-1095-1-git-send-email-hayeswang@realtek.com>
	<20130709.125305.1668056299963467935.davem@davemloft.net>
	<20130709230015.GA6843@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Wed, 10 Jul 2013 01:00:16 +0200

> David Miller <davem@davemloft.net> :
> [...]
>> Francois, please review.
> 
> The style is consistent with the driver.
> 
> The commit message may state that this 8411 chipset does not require
> any special action in rtl_link_chg_patch (whence differing from the
> previous "F" 8411).
> 
> Most of the code shared by rtl_hw_start_8168g_2 and rtl_hw_start_8411_2
> is already factored out. There is not much to win here.
> 
> The new RTL_GIGA_MAC_VER_XY id is added in the required places.
> 
> It builds.
> 
> It's fine.

Thanks for reviewing, applied.
