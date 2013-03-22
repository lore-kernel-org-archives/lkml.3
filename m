Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab3CVOTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:19:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49786 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3CVOTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:19:02 -0400
Date: Fri, 22 Mar 2013 10:19:00 -0400 (EDT)
Message-Id: <20130322.101900.1947638393872492900.davem@davemloft.net>
To: benmcollins13@gmail.com
Cc: ben.c@servergy.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] phy: Add XGMII phy interface type
From: David Miller <davem@davemloft.net>
In-Reply-To: <5BDCE647-67A3-423B-AB9C-8C50CC0B6C02@gmail.com>
References: <E1UJ1fR-0004hy-AI@swissweb.swissdisk.com>
	<20130322.101259.1120794715082991238.davem@davemloft.net>
	<5BDCE647-67A3-423B-AB9C-8C50CC0B6C02@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 22 Mar 2013 07:19:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Collins <benmcollins13@gmail.com>
Date: Fri, 22 Mar 2013 10:17:35 -0400

> On Mar 22, 2013, at 10:12 AM, David Miller <davem@davemloft.net> wrote:
> 
>> From: Ben Collins <ben.c@servergy.com>
>> Date: Mon, 18 Mar 2013 19:53:42 -0400
>> 
>>> Used by systems based on certain Freescale SoCs (specifically the
>>> Servergy CTS-1000 system).
>>> 
>>> Signed-off-by: Ben Collins <ben.c@servergy.com>
>> 
>> You can resubmit this patch when you submit a driver upstream that
>> uses it, so we can see what the use case looks like.
> 
> That patch is getting sent soon. It's starting out in staging. Should I Cc you on that?

Why don't you wait until the driver is good enough for drivers/net proper?
