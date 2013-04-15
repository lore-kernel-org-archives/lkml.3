Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab3DOSKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 14:10:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34734 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3DOSKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 14:10:23 -0400
Date: Mon, 15 Apr 2013 14:10:20 -0400 (EDT)
Message-Id: <20130415.141020.1721813812373854975.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        yongjun_wei@trendmicro.com.cn
Subject: Re: [PATCH] net/macb: fix error return code in macb_probe()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1366013073-22934-1-git-send-email-nicolas.ferre@atmel.com>
References: <1366013073-22934-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 15 Apr 2013 11:10:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Mon, 15 Apr 2013 10:04:33 +0200

> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.
> 
> Original-idea-by: <yongjun_wei@trendmicro.com.cn>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Applied.
