Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaHVTfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:35:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53634 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaHVTfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:35:51 -0400
Date: Fri, 22 Aug 2014 12:35:51 -0700 (PDT)
Message-Id: <20140822.123551.2188211356695902205.davem@davemloft.net>
To: lftan@altera.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lftan.linux@gmail.com, peppe.cavallaro@st.com, vbridger@altera.com
Subject: Re: [PATCH] net: stmmac: add fix_mac_speed support for socfpga
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408516413-2928-1-git-send-email-lftan@altera.com>
References: <1408516413-2928-1-git-send-email-lftan@altera.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Aug 2014 12:35:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ley Foon Tan <lftan@altera.com>
Date: Wed, 20 Aug 2014 14:33:33 +0800

> This patch adds fix_mac_speed() support for
> Altera socfpga Ethernet controller. Emac splitter is a
> soft IP core in FPGA system that converts GMII interface from
> Synopsys mac to RGMII/SGMII interface. This splitter core is
> an optional IP if user would like to use RGMII/SGMII
> interface in their system. Software needs to update a register
> in splitter core when there is speed change.
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>

Applied.
