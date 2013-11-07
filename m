Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3KGUhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:37:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54977 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3KGUhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:37:31 -0500
Date: Thu, 07 Nov 2013 15:37:29 -0500 (EST)
Message-Id: <20131107.153729.485901803954655270.davem@davemloft.net>
To: jonas.jensen@gmail.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        f.fainelli@gmail.com, grant.likely@secretlab.ca
Subject: Re: [PATCH v2] phy: Add MOXA MDIO driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383666901-22354-1-git-send-email-jonas.jensen@gmail.com>
References: <1383317673-14704-1-git-send-email-jonas.jensen@gmail.com>
	<1383666901-22354-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 07 Nov 2013 12:37:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Jensen <jonas.jensen@gmail.com>
Date: Tue,  5 Nov 2013 16:55:01 +0100

> The MOXA UC-711X hardware(s) has an ethernet controller that seem
> to be developed internally. The IC used is "RTL8201CP".
> 
> This patch adds an MDIO driver which handles the MII bus.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Applied, thanks Jonas.
