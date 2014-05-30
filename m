Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720AbaE3Wk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 18:40:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60085 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaE3Wk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 18:40:58 -0400
Date: Fri, 30 May 2014 15:40:57 -0700 (PDT)
Message-Id: <20140530.154057.1365325960228216056.davem@davemloft.net>
To: himangi774@gmail.com
Cc: cascardo@linux.vnet.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH v3] ehea: Introduce the use of the managed version of
 kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140528142309.GA4371@himangi-Dell>
References: <20140528142309.GA4371@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 May 2014 15:40:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Wed, 28 May 2014 19:53:09 +0530

> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions. Also, linux/device.h is added to make sure the devm_*()
> routine declarations are unambiguously available.
> 
> The following Coccinelle semantic patch was used for making the change:
 ...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Compile-Tested-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> ---
> v3: add space in linux/device.h include

Applied to net-next, thanks.
