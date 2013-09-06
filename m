Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3IFSrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:47:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33598 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3IFSro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:47:44 -0400
Date: Fri, 06 Sep 2013 14:47:42 -0400 (EDT)
Message-Id: <20130906.144742.21205817877936193.davem@davemloft.net>
To: michael.opdenacker@free-electrons.com
Cc: eli@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlx5: remove unused MLX5_DEBUG param in Kconfig
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378468162-3109-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1378468162-3109-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Sep 2013 11:47:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Fri,  6 Sep 2013 13:49:22 +0200

> This patch proposes to remove the MLX5_DEBUG kernel configuration
> parameter defined in drivers/net/ethernet/mellanox/mlx5/core/Kconfig,
> but used nowhere in the makefiles and source code.
> 
> This could also be fixed by using this parameter,
> but this may be a leftover from driver development...
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied.
