Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab3CVONy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:13:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49712 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3CVONx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:13:53 -0400
Date: Fri, 22 Mar 2013 10:13:51 -0400 (EDT)
Message-Id: <20130322.101351.803684806942512280.davem@davemloft.net>
To: afleming@freescale.com
Cc: linux-kernel@vger.kernel.org, kumar.gala@freescale.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] phy: Add support for VSC8234
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1UJ1fR-0004hp-2j@swissweb.swissdisk.com>
References: <E1UJ1fR-0004hp-2j@swissweb.swissdisk.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 22 Mar 2013 07:13:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Fleming <afleming@freescale.com>
Date: Sun, 16 Oct 2011 01:49:49 -0500

> No functional changes other than to recognize this PHYID.
> 
> Signed-off-by: Andy Fleming <afleming@freescale.com>
> Signed-off-by: Kumar Gala <kumar.gala@freescale.com>
> Signed-off-by: Ben Collins <ben.c@servergy.com>

Please do not submit patches with the commit date integrated
into your formal email headers.

This screws up archives and patch queue maintainence systems which
order submissions by date.

Thanks.
