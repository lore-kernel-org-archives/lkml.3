Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbaEXSGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 14:06:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37721 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaEXSGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 14:06:47 -0400
Date: Sat, 24 May 2014 14:06:45 -0400 (EDT)
Message-Id: <20140524.140645.430202997634061971.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-05-23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140523150733.GC13311@tuxdriver.com>
References: <20140523150733.GC13311@tuxdriver.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 May 2014 11:06:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 23 May 2014 11:07:34 -0400

> I have two more fixes intended for the 3.15 stream...
> 
> For the iwlwifi one, Emmanuel says:
> 
> "A race has been discovered in the beacon filtering code. Since the
> fix is too big for 3.15, I disable here the feature."
> 
> For the bluetooth one, Gustavo says:
> 
> "This pull request contains a very important fix for 3.15. Here we fix the
> permissions of a debugfs file that would otherwise allow unauthorized users
> to write content to it."
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.

