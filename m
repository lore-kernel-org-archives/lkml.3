Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaLIVFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:05:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38698 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaLIVFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:05:48 -0500
Date: Tue, 09 Dec 2014 16:05:45 -0500 (EST)
Message-Id: <20141209.160545.1119651138018658437.davem@davemloft.net>
To: joestringer@nicira.com
Cc: netdev@vger.kernel.org, ariel.elior@qlogic.com, jesse@nicira.com,
        therbert@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] bnx2x: Implement ndo_gso_check()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417808146-3436-1-git-send-email-joestringer@nicira.com>
References: <1417808146-3436-1-git-send-email-joestringer@nicira.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 13:05:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Stringer <joestringer@nicira.com>
Date: Fri,  5 Dec 2014 11:35:46 -0800

> Use vxlan_gso_check() to advertise offload support for this NIC.
> 
> Signed-off-by: Joe Stringer <joestringer@nicira.com>

Applied, thanks.
