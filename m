Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaFWAP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 20:15:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49548 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaFWAP0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 20:15:26 -0400
Date: Sun, 22 Jun 2014 17:15:25 -0700 (PDT)
Message-Id: <20140622.171525.1231955995045407676.davem@davemloft.net>
To: manuel.schoelling@gmx.de
Cc: sergei.shtylyov@cogentembedded.com, michal.simek@xilinx.com,
        anirudh@xilinx.com, John.Linn@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xilinx: Fix compiler warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403436294-21301-1-git-send-email-manuel.schoelling@gmx.de>
References: <53A6BAC5.80206@cogentembedded.com>
	<1403436294-21301-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 22 Jun 2014 17:15:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Schölling <manuel.schoelling@gmx.de>
Date: Sun, 22 Jun 2014 13:24:54 +0200

> The time comparsion functions require arguments of type unsigned long
> instead of (signed) long.
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

Applied to net-next, thanks.
