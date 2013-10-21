Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3JUWrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:47:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44324 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3JUWrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:47:21 -0400
Date: Mon, 21 Oct 2013 18:47:19 -0400 (EDT)
Message-Id: <20131021.184719.447059170292983994.davem@davemloft.net>
To: michael.opdenacker@free-electrons.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethernet: moxa: remove duplicate includes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382246036-19253-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382246036-19253-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 21 Oct 2013 15:47:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Sun, 20 Oct 2013 07:13:56 +0200

> Reported by "make includecheck"
> 
> Tested that drivers/net/ethernet/moxa/moxart_ether.c still compiles
> well on ARM
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied.
