Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaAFUvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:51:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34535 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbaAFUvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:51:18 -0500
Date: Mon, 06 Jan 2014 15:51:16 -0500 (EST)
Message-Id: <20140106.155116.2301761686285996039.davem@davemloft.net>
To: linux@roeck-us.net
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] isdn: Drop big endian cpp checks from telespci and
 hfc_pci drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1388982699-11514-1-git-send-email-linux@roeck-us.net>
References: <1388982699-11514-1-git-send-email-linux@roeck-us.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 Jan 2014 12:51:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Sun,  5 Jan 2014 20:31:39 -0800

> With arm:allmodconfig, building the Teles PCI driver fails with
> 
> telespci.c:294:2: error: #error "not running on big endian machines now"
> 
> Similar, building the driver for HFC PCI-Bus cards fails with
> 
> hfc_pci.c:1647:2: error: #error "not running on big endian machines now"
> 
> Remove the big endian cpp check from both drivers to fix the build errors.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Applied, thank you.
