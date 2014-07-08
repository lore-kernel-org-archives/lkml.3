Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaGHUQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:16:39 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:43043 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaGHUQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:16:37 -0400
Date: Tue, 8 Jul 2014 22:16:30 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [PATCH net] r8169: disable L23
Message-ID: <20140708201630.GA31885@electric-eye.fr.zoreil.com>
References: <1394712342-15778-6-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394712342-15778-6-Taiwan-albertk@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> For RTL8411, RTL8111G, RTL8402, RTL8105, and RTL8106, the nic couldn't
> leave the power saving mode of L23 for certain situation. This causes
> the device lost for the system. Disable the L23 mode to avoid it.

Ok with the patch as it exactly addresses the required hw_start methods
to cover the aforementionned RTL8xyz range.

Can you elaborate what L23 is or should the commit message be reworded
as "Disable a (yet undocumented) power saving feature that randomly
causes RTL8411, RTL8111G, RTL8402, RTL8105, and RTL8106 devices to be
lost on some systems." ?

If nobody really understands what the bug is nor what the specific
circumstances that triggers it are, it would be nice to state it clearly.
If not there is plenty of room to improve the description before it
comes close to full disclosure.

-- 
Ueimor
