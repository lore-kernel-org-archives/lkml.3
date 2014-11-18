Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbaKRU42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:56:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56854 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577AbaKRU4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:56:25 -0500
Date: Tue, 18 Nov 2014 15:56:23 -0500 (EST)
Message-Id: <20141118.155623.1918421784549626366.davem@davemloft.net>
To: joestringer@nicira.com
Cc: netdev@vger.kernel.org, ogerlitz@mellanox.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] vxlan: Inline vxlan_gso_check().
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416270294-21516-1-git-send-email-joestringer@nicira.com>
References: <1416270294-21516-1-git-send-email-joestringer@nicira.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Nov 2014 12:56:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Stringer <joestringer@nicira.com>
Date: Mon, 17 Nov 2014 16:24:54 -0800

> Suggested-by: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Joe Stringer <joestringer@nicira.com>

Applied.
