Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaESA46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 20:56:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44205 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaESA44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 20:56:56 -0400
Date: Sun, 18 May 2014 20:56:55 -0400 (EDT)
Message-Id: <20140518.205655.2295290164768048817.davem@davemloft.net>
To: himangi774@gmail.com
Cc: cascardo@linux.vnet.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] ehea: Introduce the use of the managed version of
 kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140516180725.GA12976@himangi-Dell>
References: <20140516180725.GA12976@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 May 2014 17:56:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Fri, 16 May 2014 23:37:25 +0530

> Not compile tested due to incompatible architecture.

Please add an explicit linux/device.h include to make absolutely
sure the devm_*() are available.
