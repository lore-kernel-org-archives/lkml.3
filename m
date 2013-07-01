Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3GAU3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:29:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43697 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3GAU3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:29:54 -0400
Date: Mon, 01 Jul 2013 13:29:53 -0700 (PDT)
Message-Id: <20130701.132953.922899681299706282.davem@davemloft.net>
To: christoph.muellner@theobroma-systems.com
Cc: festevam@gmail.com, linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, fabio.estevam@freescale.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: fec: Fix multicast list setup in fec_restart().
From: David Miller <davem@davemloft.net>
In-Reply-To: <1372360703-20526-1-git-send-email-christoph.muellner@theobroma-systems.com>
References: <61455.62.178.124.14.1371832855.squirrel@mail.theobroma-systems.com>
	<1372360703-20526-1-git-send-email-christoph.muellner@theobroma-systems.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Muellner <christoph.muellner@theobroma-systems.com>
Date: Thu, 27 Jun 2013 21:18:23 +0200

> Setup the multicast list of the net_device instead of
> clearing it blindly. This restores the multicast groups
> in case of a link down/up event or when resuming from
> suspend.
> 
> Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>

Applied.
