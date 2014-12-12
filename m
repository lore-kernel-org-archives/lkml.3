Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030892AbaLLQ70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:59:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36373 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaLLQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:59:25 -0500
Date: Fri, 12 Dec 2014 11:59:22 -0500 (EST)
Message-Id: <20141212.115922.687789059853236747.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: sergei.shtylyov@cogentembedded.com, paulus@samba.org,
        linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH v2 0/6] net-PPP: Deletion of a few unnecessary checks
From: David Miller <davem@davemloft.net>
In-Reply-To: <548B1E44.6050005@users.sourceforge.net>
References: <548B0A29.8050503@users.sourceforge.net>
	<20141212.105106.1162681032492664308.davem@davemloft.net>
	<548B1E44.6050005@users.sourceforge.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Dec 2014 08:59:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 12 Dec 2014 17:56:36 +0100

> Where should "the error pointers" be stored instead?

A local variable, before you assign it into the datastructure.
