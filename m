Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab3CLKzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:55:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537Ab3CLKzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:55:22 -0400
Date: Tue, 12 Mar 2013 06:55:27 -0400 (EDT)
Message-Id: <20130312.065527.477313007496838625.davem@redhat.com>
To: marex@denx.de
Cc: hector.palacios@digi.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] phy/micrel: Add support for KSZ8031
From: David Miller <davem@redhat.com>
In-Reply-To: <201303111339.46507.marex@denx.de>
References: <1362991803-4610-1-git-send-email-hector.palacios@digi.com>
	<201303111339.46507.marex@denx.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Mon, 11 Mar 2013 13:39:46 +0100

> Dear Hector Palacios,
> 
>> Micrel PHY KSZ8031 is similar to KSZ8021 and also requires the special
>> initialization of "Operation Mode Strap Override" in reg 0x16
>> introduced in 212ea99 (phy/micrel: Implement support for KSZ8021).
>> 
>> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> 
> I dont have any board with this one, yet I think this change is correct, so:
> 
> Reviewed-by: Marek Vasut <marex@denx.de>

Applied.
