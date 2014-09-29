Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaI2UM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:12:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33597 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaI2UMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:12:55 -0400
Date: Mon, 29 Sep 2014 16:12:53 -0400 (EDT)
Message-Id: <20140929.161253.1302757975839499212.davem@davemloft.net>
To: santosh.shilimkar@ti.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org, sandeep_n@ti.com,
        joe@perches.com
Subject: Re: [PATCH v5 2/3] net: Add Keystone NetCP ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <5429BAD0.1050101@ti.com>
References: <1411667317-1163-3-git-send-email-santosh.shilimkar@ti.com>
	<20140929.155200.2231132602322345812.davem@davemloft.net>
	<5429BAD0.1050101@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Sep 2014 13:12:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Mon, 29 Sep 2014 16:02:24 -0400

> We are badly missing mainline network driver support for the Keystone
> and hence I request you to help here.

It is absolutely not reasonable for you depend specifically upon me
for top-level review of a given change, sorry.
