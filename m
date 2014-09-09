Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaIIS7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:59:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59659 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaIIS7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:59:30 -0400
Date: Tue, 09 Sep 2014 11:59:28 -0700 (PDT)
Message-Id: <20140909.115928.2263127447345685807.davem@davemloft.net>
To: varkabhadram@gmail.com
Cc: netdev@vger.kernel.org, balbi@ti.com, mugunthanvnm@ti.com,
        linux@rainbow-software.org, linux-kernel@vger.kernel.org,
        varkab@cdac.in
Subject: Re: [PATCH net-next] ethernet: ti: remove unwanted THIS_MODULE
 macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410148699-3724-1-git-send-email-varkab@cdac.in>
References: <1410148699-3724-1-git-send-email-varkab@cdac.in>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Sep 2014 11:59:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkabhadram@gmail.com>
Date: Mon,  8 Sep 2014 09:28:19 +0530

> It removes the owner field updation of driver structure.
> It will be automatically updated by module_platform_driver()
> 
> Signed-off-by: Varka Bhadram <varkab@cdac.in>

Applied, thanks.
