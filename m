Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaEUUab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:30:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55734 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaEUUa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:30:29 -0400
Date: Wed, 21 May 2014 16:30:27 -0400 (EDT)
Message-Id: <20140521.163027.379421150593976730.davem@davemloft.net>
To: himangi774@gmail.com
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH v2] ieee802154: Introduce the use of the managed
 version of kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140519165511.GA8966@himangi-Dell>
References: <20140519165511.GA8966@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 May 2014 13:30:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Mon, 19 May 2014 22:25:11 +0530

> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions. An explicit linux/device.h include is added to make sure
> the devm_*() routine declarations are unambiguously available.
> 
> The following Coccinelle semantic patch was used for making the change:
 ...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> v2: add explicit include for linux/device.h

Applied, thank you.
