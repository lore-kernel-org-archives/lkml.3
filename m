Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaESBO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:14:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44294 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaESBO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:14:58 -0400
Date: Sun, 18 May 2014 21:14:57 -0400 (EDT)
Message-Id: <20140518.211457.1577062584301411622.davem@davemloft.net>
To: cengelma@gmx.at
Cc: netdev@vger.kernel.org, amirv@mellanox.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx4_en: Fix uninitialized use of 'port_up' in
 mlx4_en_set_channels()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400363523-18371-1-git-send-email-cengelma@gmx.at>
References: <1400363523-18371-1-git-send-email-cengelma@gmx.at>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 May 2014 18:14:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Engelmayer <cengelma@gmx.at>
Date: Sat, 17 May 2014 23:52:03 +0200

> Function mlx4_en_set_channels() stops running ports before performing the
> requested action. In that case local variable 'port_up' is set so that the
> port is restarted at the end of the function, however, in case the port was
> not stopped, variable 'port_up' is left uninitialized and the behaviour is
> undetermined. Detected by Coverity - CID 751497.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Applied, thanks.
