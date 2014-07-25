Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbaGYGZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:25:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58705 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbaGYGZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:25:25 -0400
Date: Thu, 24 Jul 2014 23:25:23 -0700 (PDT)
Message-Id: <20140724.232523.2174957335001728554.davem@davemloft.net>
To: himangi774@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] igmp: remove exceptional & on function name
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140724201844.GA16240@himangi-Dell>
References: <20140724201844.GA16240@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Jul 2014 23:25:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Fri, 25 Jul 2014 01:48:44 +0530

> In this file, function names are otherwise used as pointers without &.
> 
> A simplified version of the Coccinelle semantic patch that makes this
> change is as follows: 
 ...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.
