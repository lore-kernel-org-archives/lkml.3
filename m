Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaLRUdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 15:33:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48545 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaLRUdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 15:33:04 -0500
Date: Thu, 18 Dec 2014 15:32:59 -0500 (EST)
Message-Id: <20141218.153259.1434707913030906643.davem@davemloft.net>
To: johan.hedberg@gmail.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2014-12-17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141217204614.GA15480@t440s.P-661HNU-F1>
References: <20141217204614.GA15480@t440s.P-661HNU-F1>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Dec 2014 12:33:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Wed, 17 Dec 2014 22:46:14 +0200

> Here's the first direct (i.e. skipping the wireless tree) bluetooth pull
> request for you, intended for 3.19. It's just one patch: a fix from
> Marcel for for remote service discovery filtering which also fixes a
> 'used uninitialized' compiler warning.
> 
> Please let me know if there are any issues pulling. Thanks.

Pulled, thanks Johan.
