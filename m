Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3CKQHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:07:44 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:51616 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3CKQHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:07:42 -0400
X-Auth-Info: avQsXiszA0pBodjr5vw7VDKv6aWhX5wS3nG7fX6gEGU=
From: Marek Vasut <marex@denx.de>
To: Hector Palacios <hector.palacios@digi.com>
Subject: Re: [PATCH 1/2] phy/micrel: Add support for KSZ8031
Date: Mon, 11 Mar 2013 13:39:46 +0100
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net
References: <1362991803-4610-1-git-send-email-hector.palacios@digi.com>
In-Reply-To: <1362991803-4610-1-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303111339.46507.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hector Palacios,

> Micrel PHY KSZ8031 is similar to KSZ8021 and also requires the special
> initialization of "Operation Mode Strap Override" in reg 0x16
> introduced in 212ea99 (phy/micrel: Implement support for KSZ8021).
> 
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>

I dont have any board with this one, yet I think this change is correct, so:

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
