Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3IWVil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:38:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45864 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3IWVij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:38:39 -0400
Date: Mon, 23 Sep 2013 17:38:37 -0400 (EDT)
Message-Id: <20130923.173837.1100130860877105243.davem@davemloft.net>
To: peter.senna@gmail.com
Cc: eilong@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 09/19] net: Change variable type to bool
From: David Miller <davem@davemloft.net>
In-Reply-To: <1379802471-30252-9-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
	<1379802471-30252-9-git-send-email-peter.senna@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 23 Sep 2013 14:38:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using the same prefix, "net: " for several patches gives no information
to the person reading the shortlog.

Use more specific subsystem prefixes, such as "bnx2x: "myri10ge: ",
"ipv6: ", etc.
