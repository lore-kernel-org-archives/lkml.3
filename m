Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3JBUMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:12:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48747 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3JBUML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:12:11 -0400
Date: Wed, 02 Oct 2013 16:12:09 -0400 (EDT)
Message-Id: <20131002.161209.5649210659405467.davem@davemloft.net>
To: robherring2@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH 0/3] calxedaxgmac: fixes for xgmac_set_rx_mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380571937-23439-1-git-send-email-robherring2@gmail.com>
References: <1380571937-23439-1-git-send-email-robherring2@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 02 Oct 2013 13:12:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robherring2@gmail.com>
Date: Mon, 30 Sep 2013 15:12:14 -0500

> This is a couple of fixes related to xgmac_set_rx_mode. The changes are
> necessary for "bridge fdb add" to work correctly.

Series applied, thanks Rob.
