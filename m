Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3GIXA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 19:00:28 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:41795 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3GIXA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 19:00:27 -0400
Date: Wed, 10 Jul 2013 01:00:16 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Miller <davem@davemloft.net>
Cc: hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: add a new chip for RTL8411
Message-ID: <20130709230015.GA6843@electric-eye.fr.zoreil.com>
References: <1373274541-1095-1-git-send-email-hayeswang@realtek.com>
 <20130709.125305.1668056299963467935.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709.125305.1668056299963467935.davem@davemloft.net>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> :
[...]
> Francois, please review.

The style is consistent with the driver.

The commit message may state that this 8411 chipset does not require
any special action in rtl_link_chg_patch (whence differing from the
previous "F" 8411).

Most of the code shared by rtl_hw_start_8168g_2 and rtl_hw_start_8411_2
is already factored out. There is not much to win here.

The new RTL_GIGA_MAC_VER_XY id is added in the required places.

It builds.

It's fine.

-- 
Ueimor
