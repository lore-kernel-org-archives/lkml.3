Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaCZTr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:47:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46309 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaCZTrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:47:23 -0400
Date: Wed, 26 Mar 2014 15:47:21 -0400 (EDT)
Message-Id: <20140326.154721.548465980290363881.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, shahed.shaikh@qlogic.com,
        Dept-HSGLinuxNICDev@qlogic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/7] qlcnic: Remove casts of pointer to same
 type
From: David Miller <davem@davemloft.net>
In-Reply-To: <ac82455e9d2f0487a3f96c44a41b5557fd09af95.1395692043.git.joe@perches.com>
References: <cover.1395692043.git.joe@perches.com>
	<ac82455e9d2f0487a3f96c44a41b5557fd09af95.1395692043.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Mar 2014 12:47:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 24 Mar 2014 13:15:37 -0700

> Casting a pointer to a pointer of the same type is pointless,
> so remove these unnecessary casts.
> 
> Done via coccinelle script:
> 
> $ cat typecast_2.cocci
> @@
> type T;
> T *foo;
> @@
> 
> -	(T *)foo
> +	foo
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
