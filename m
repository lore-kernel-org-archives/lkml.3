Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaKLS4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:56:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45324 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaKLS4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:56:10 -0500
Date: Wed, 12 Nov 2014 13:56:07 -0500 (EST)
Message-Id: <20141112.135607.970670076636942787.davem@davemloft.net>
To: johan@kernel.org
Cc: f.fainelli@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/9] net: phy: micrel: refactoring and KSZ8081/KSZ8091
 features
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415732415-10363-1-git-send-email-johan@kernel.org>
References: <1415732415-10363-1-git-send-email-johan@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Nov 2014 10:56:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>
Date: Tue, 11 Nov 2014 20:00:06 +0100

> This series cleans up and refactors parts of the micrel PHY driver, and
> adds support for broadcast-address-disable and led-mode configuration
> for KSZ8081 and KSZ8091 PHYs.
> 
> Specifically, this enables dual KSZ8081 setups (which are limited to
> using address 0 and 3).
> 
> A follow up series will add device-type abstraction which will allow for
> further refactoring and shared initialisation code.

Series applied, thanks Johan.
