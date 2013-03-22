Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab3CVO1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:27:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49986 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab3CVO1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:27:40 -0400
Date: Fri, 22 Mar 2013 10:27:38 -0400 (EDT)
Message-Id: <20130322.102738.100763719710671227.davem@davemloft.net>
To: benmcollins13@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] phy: Add XGMII phy interface type
From: David Miller <davem@davemloft.net>
In-Reply-To: <9CC1FA76-1620-4E0F-82DC-89535633329F@gmail.com>
References: <5BDCE647-67A3-423B-AB9C-8C50CC0B6C02@gmail.com>
	<20130322.101900.1947638393872492900.davem@davemloft.net>
	<9CC1FA76-1620-4E0F-82DC-89535633329F@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 22 Mar 2013 07:27:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Collins <benmcollins13@gmail.com>
Date: Fri, 22 Mar 2013 10:22:05 -0400

> It's code that I've manually stripped down as a subset of a larger
> code base for Freescale's DPAA driver. I've only tested it on our
> (Servergy's) platform, so until it gets more broad testing (and some
> code review), I want to at least get it into staging so our hardware
> is supported.

Then why don't you submit the PHY type addition with the staging
driver, which will be the only user, and you can add my:

Acked-by: David S. Miller <davem@davemloft.net>

to that.

Thanks.
