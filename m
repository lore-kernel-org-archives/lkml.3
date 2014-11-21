Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189AbaKUTQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:16:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37661 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaKUTQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:16:28 -0500
Date: Fri, 21 Nov 2014 14:16:21 -0500 (EST)
Message-Id: <20141121.141621.653528959311466817.davem@davemloft.net>
To: johan@kernel.org
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bth@kamstrup.dk, s.hauer@pengutronix.de, mark.rutland@arm.com
Subject: Re: [PATCH 00/10] net: phy: add device-type abstraction
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416398363-32306-1-git-send-email-johan@kernel.org>
References: <1416398363-32306-1-git-send-email-johan@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 11:16:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>
Date: Wed, 19 Nov 2014 12:59:13 +0100

> This series adds device and device-type abstractions to the micrel
> driver, and enables support for RMII-reference clock selection for
> KSZ8081 and KSZ8091 devices.

Series applied, thanks Johan.
