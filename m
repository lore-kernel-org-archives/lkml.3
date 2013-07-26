Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab3GZWkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:40:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38673 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab3GZWkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:40:22 -0400
Date: Fri, 26 Jul 2013 15:40:21 -0700 (PDT)
Message-Id: <20130726.154021.878367099404960400.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, alex.bluesman.smirnov@gmail.com,
        dbaryshkov@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 31/36] net: ieee802154: convert class code to use
 dev_groups
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374703539-9705-32-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
	<1374703539-9705-32-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 26 Jul 2013 15:40:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 24 Jul 2013 15:05:34 -0700

> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the ieee802154 class code to use
> the correct field.
> 
> Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> netdev@ maintainers, feel free to take this through your tree, or ACK it
> and I can take it through mine.

You can take it directly I don't anticipate any conflicts:

Acked-by: David S. Miller <davem@davemloft.net>
