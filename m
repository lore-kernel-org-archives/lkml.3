Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3GTAfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 20:35:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54423 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3GTAfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 20:35:01 -0400
Date: Fri, 19 Jul 2013 17:35:00 -0700 (PDT)
Message-Id: <20130719.173500.52932904518620157.davem@davemloft.net>
To: alexj@rosedu.org
Cc: isdn@linux-pingi.de, standby24x7@gmail.com, gregkh@linuxfoundation.org,
        jkosina@suse.cz, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN: replace sum of bitmasks with OR operation.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374147408-14890-1-git-send-email-alexj@rosedu.org>
References: <1374147408-14890-1-git-send-email-alexj@rosedu.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 19 Jul 2013 17:35:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandru Juncu <alexj@rosedu.org>
Date: Thu, 18 Jul 2013 14:36:48 +0300

> Suggested by coccinelle and manually verified.
> 
> Signed-off-by: Alexandru Juncu <alexj@rosedu.org>

Applied.
