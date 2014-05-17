Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbaEQFhD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 01:37:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53040 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbaEQFhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 01:37:00 -0400
Date: Sat, 17 May 2014 01:36:55 -0400 (EDT)
Message-Id: <20140517.013655.349586284786993619.davem@davemloft.net>
To: gang.chen.5i5j@gmail.com
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        gxt@mprc.pku.edu.cn, matanb@mellanox.com, ogerlitz@mellanox.com,
        eyalpe@mellanox.com, amirv@mellanox.com, sbohrer@rgmadvisors.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] drivers: net: ethernet: mellanox: mlx4: let mlx4
 depend on SMP
From: David Miller <davem@davemloft.net>
In-Reply-To: <5376F2F8.3010603@gmail.com>
References: <5376F2F8.3010603@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 16 May 2014 22:37:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gang <gang.chen.5i5j@gmail.com>
Date: Sat, 17 May 2014 13:26:16 +0800

> 'struct irq_affinity_notify' and the related functions are only defined
> when SMP enabled, so at present, mlx4 has to only run under SMP.
> 
> The related error (allmodconfig under unicore32):

Making the entire driver depend upon SMP is not the answer,
other Mellanox developers said that a proper fix is pending
so please be patient.
