Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbaEITvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:51:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39200 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaEITvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:51:49 -0400
Date: Fri, 09 May 2014 15:51:47 -0400 (EDT)
Message-Id: <20140509.155147.151325080919519192.davem@davemloft.net>
To: jhovold@gmail.com
Cc: f.fainelli@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mugunthanvnm@ti.com
Subject: Re: [PATCH RESEND 0/5] net: cpsw and mdio-gpio fixes for
 v3.15-final
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399536564-7626-1-git-send-email-jhovold@gmail.com>
References: <1399534639-4947-1-git-send-email-jhovold@gmail.com>
	<1399536564-7626-1-git-send-email-jhovold@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 May 2014 12:51:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>
Date: Thu,  8 May 2014 10:09:19 +0200

> These patches against v3.15-rc4 fix a few issues in the cpsw and
> mdio-gpio drivers.
> 
> Resend with proper stable CC (git send-email still fails to parse the
> #-part of the tag unless address is enclosed in <> it seems).
> 
> Sorry about the noise.

Series applied, thanks.
