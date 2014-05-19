Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaESA53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 20:57:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44212 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaESA52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 20:57:28 -0400
Date: Sun, 18 May 2014 20:57:26 -0400 (EDT)
Message-Id: <20140518.205726.138371667211604965.davem@davemloft.net>
To: himangi774@gmail.com
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] ieee802154: Introduce the use of the managed version
 of kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140516180935.GA13004@himangi-Dell>
References: <20140516180935.GA13004@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 May 2014 17:57:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Fri, 16 May 2014 23:39:35 +0530

> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions.

Likewise please add an explicit linux/device.h include to make sure
the devm_*() routine declarations are unambiguously available.
