Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbbA0AYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:24:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46204 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbbA0AYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:24:01 -0500
Date: Mon, 26 Jan 2015 15:46:34 -0800 (PST)
Message-Id: <20150126.154634.1861373962968263276.davem@davemloft.net>
To: joestringer@nicira.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dev@openvswitch.org,
        pshelar@nicira.com
Subject: Re: [PATCH net-next v14 0/5] openvswitch: Introduce 128-bit unique
 flow identifiers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421887372-56414-1-git-send-email-joestringer@nicira.com>
References: <1421887372-56414-1-git-send-email-joestringer@nicira.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Jan 2015 15:46:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Stringer <joestringer@nicira.com>
Date: Wed, 21 Jan 2015 16:42:47 -0800

> This series extends the openvswitch datapath interface for flow commands to use
> 128-bit unique identifiers as an alternative to the netlink-formatted flow key.
> This significantly reduces the cost of assembling messages between the kernel
> and userspace, in particular improving Open vSwitch revalidation performance by
> 40% or more.

Series applied, thanks.
