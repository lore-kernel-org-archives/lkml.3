Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbaGKWHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:07:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57985 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaGKWHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:07:08 -0400
Date: Fri, 11 Jul 2014 15:07:07 -0700 (PDT)
Message-Id: <20140711.150707.1210217424743545003.davem@davemloft.net>
To: himangi774@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] ipv6: Use BUG_ON
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140711202717.GA3848@himangi-Dell>
References: <20140711202717.GA3848@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Jul 2014 15:07:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Sat, 12 Jul 2014 01:57:17 +0530

> The semantic patch that makes this transformation is as follows:
> 
> // <smpl>
> @@ expression e; @@
> -if (e) BUG();
> +BUG_ON(e);
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.
