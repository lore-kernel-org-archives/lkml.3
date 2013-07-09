Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3GIT4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 15:56:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58952 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3GIT4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 15:56:38 -0400
Date: Tue, 09 Jul 2013 12:56:38 -0700 (PDT)
Message-Id: <20130709.125638.86796731717687170.davem@davemloft.net>
To: khlebnikov@openvz.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, neepatel@cisco.com,
        nistrive@cisco.com, roprabhu@cisco.com, benve@cisco.com
Subject: Re: [PATCH] drivers/net: enic: release rtnl_lock on error-path
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130708072251.20540.50413.stgit@zurg>
References: <20130708072251.20540.50413.stgit@zurg>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Mon, 08 Jul 2013 11:22:51 +0400

> enic_change_mtu_work() must call rtnl_unlock() on all exiting paths.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Applied.
