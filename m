Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab3CLKzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:55:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537Ab3CLKzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:55:31 -0400
Date: Tue, 12 Mar 2013 06:55:36 -0400 (EDT)
Message-Id: <20130312.065536.265307680758561426.davem@redhat.com>
To: hector.palacios@digi.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, marex@denx.de
Subject: Re: [PATCH 2/2] phy/micrel: move flag handling to function for
 common use
From: David Miller <davem@redhat.com>
In-Reply-To: <1362991803-4610-2-git-send-email-hector.palacios@digi.com>
References: <1362991803-4610-1-git-send-email-hector.palacios@digi.com>
	<1362991803-4610-2-git-send-email-hector.palacios@digi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hector Palacios <hector.palacios@digi.com>
Date: Mon, 11 Mar 2013 09:50:03 +0100

> The flag MICREL_PHY_50MHZ_CLK is not of exclusive use of KSZ8051
> model. At least KSZ8021 and KSZ8031 models also use it.
> This patch moves the handling of this and future flags to a
> separate function so that the different PHY models can call it on
> their init function, if needed.
> 
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>

Applied.
