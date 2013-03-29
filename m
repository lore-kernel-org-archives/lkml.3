Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3C2TaC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:30:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56343 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab3C2TaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:30:00 -0400
Date: Fri, 29 Mar 2013 15:29:58 -0400 (EDT)
Message-Id: <20130329.152958.576829381792957267.davem@davemloft.net>
To: robherring2@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH 1/2] net: calxedaxgmac: fix rx ring handling when OOM
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364506365-13689-1-git-send-email-robherring2@gmail.com>
References: <1364506365-13689-1-git-send-email-robherring2@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 29 Mar 2013 12:30:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robherring2@gmail.com>
Date: Thu, 28 Mar 2013 16:32:44 -0500

> From: Rob Herring <rob.herring@calxeda.com>
> 
> If skb allocation for the rx ring fails repeatedly, we can reach a point
> were the ring is empty. In this condition, the driver is out of sync with
> the h/w. While this has always been possible, the removal of the skb
> recycling seems to have made triggering this problem easier.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Applied.
