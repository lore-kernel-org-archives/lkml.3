Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab3HUGeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:34:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52172 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3HUGem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:34:42 -0400
Date: Tue, 20 Aug 2013 23:34:42 -0700 (PDT)
Message-Id: <20130820.233442.598967406878017552.davem@davemloft.net>
To: skd.linux@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:net:ifb: Fixed coding style error:assignment
 in if statement
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376955577-26518-1-git-send-email-skd.linux@gmail.com>
References: <1376955577-26518-1-git-send-email-skd.linux@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 20 Aug 2013 23:34:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sanil Kumar D <skd.linux@gmail.com>
Date: Tue, 20 Aug 2013 05:09:37 +0530

> +	if (skb == NULL) {

"!skb" is preferred.

> +		if (skb == NULL) {

Likewise.

