Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaCFVy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:54:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33862 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaCFVyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:54:24 -0500
Date: Thu, 06 Mar 2014 16:54:21 -0500 (EST)
Message-Id: <20140306.165421.316751944344722461.davem@davemloft.net>
To: amirv@mellanox.com
Cc: netdev@vger.kernel.org, yevgenyp@mellanox.com, ogerlitz@mellanox.com,
        fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
        eugenia@mellanox.com
Subject: Re: [PATCH net-next] net/mlx4_en: mlx4_en_verify_params() can be
 static
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394013443-17153-1-git-send-email-amirv@mellanox.com>
References: <1394013443-17153-1-git-send-email-amirv@mellanox.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 13:54:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Vadai <amirv@mellanox.com>
Date: Wed,  5 Mar 2014 11:57:23 +0200

> From: Fengguang Wu <fengguang.wu@intel.com>
> 
> Fix static error introduced by commit:
> b97b33a3df0439401f80f041eda507d4fffa0dbf [645/653] net/mlx4_en: Verify
> mlx4_en module parameters
> 
> sparse warnings:
> drivers/net/ethernet/mellanox/mlx4/en_main.c:335:6: sparse: symbol
> 'mlx4_en_verify_params' was not declared. Should it be static?
> 
> CC: netdev@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: Eugenia Emantayev <eugenia@mellanox.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Amir Vadai <amirv@mellanox.com>

Applied, thanks.
