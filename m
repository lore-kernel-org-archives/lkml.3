Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaEZEkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 00:40:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52576 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaEZEkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 00:40:52 -0400
Date: Mon, 26 May 2014 00:40:45 -0400 (EDT)
Message-Id: <20140526.004045.1779020170437806699.davem@davemloft.net>
To: joe@perches.com
Cc: manuel.schoelling@gmx.de, kevin.curtis@farsite.co.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] wan: time_before()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401040732.22191.8.camel@joe-AO725>
References: <1401039163-10727-1-git-send-email-manuel.schoelling@gmx.de>
	<1401040732.22191.8.camel@joe-AO725>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 May 2014 21:40:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 25 May 2014 10:58:52 -0700

> On Sun, 2014-05-25 at 19:32 +0200, Manuel Schölling wrote:
>> To be future-proof and for better readability the time comparisons are
>> modified to use time_before() instead of plain, error-prone math.
> 
> Sensible change, but it seems these should be
> udelay(some_constant) instead of a a rather
> variable time wait based on a system/config
> defined jiffies.

Agreed, this code probably wants udelay(10) or something like
that.
