Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3ETVML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:12:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38095 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269Ab3ETVMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:12:05 -0400
Date: Mon, 20 May 2013 14:12:04 -0700 (PDT)
Message-Id: <20130520.141204.1030613972336983434.davem@davemloft.net>
To: peterhuewe@gmx.de
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/usb/r8152: Use module_usb_driver to register driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369081696-8149-1-git-send-email-peterhuewe@gmx.de>
References: <1369081696-8149-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 20 May 2013 14:12:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Mon, 20 May 2013 22:28:16 +0200

> Removing some boilerplate by using module_usb_driver instead of calling
> register and unregister in the otherwise empty init/exit functions.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

This driver has already been converted like this.

Please make sure your patches always apply cleanly to the most
uptodate sources.
