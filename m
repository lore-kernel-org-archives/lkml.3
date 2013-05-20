Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab3ETUme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:42:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37706 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab3ETUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:42:32 -0400
Date: Mon, 20 May 2013 13:42:32 -0700 (PDT)
Message-Id: <20130520.134232.344940542336017991.davem@davemloft.net>
To: petkan@nucleusys.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, romieu@fr.zoreil.com
Subject: Re: [PATCH] drivers: net: usb: rtl8150: concurrent URB bugfix
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1305201152001.11943@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305201152001.11943@fry.nucleusys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 20 May 2013 13:42:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>
Date: Mon, 20 May 2013 12:08:47 +0300 (EEST)

> From: Petko Manolov <petkan@nucleusys.com>
> 
> This patch fixes a potential race with concurrently running asynchronous 
> write requests.  The values for device's RX control register are now 
> stored in dynamically allocated buffers so each URB submission has it's 
> own copy.  Doing it the old way is data clobbering prone.
> 
> This patch is against latest 'net' tree.
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>

Applied, thanks.
