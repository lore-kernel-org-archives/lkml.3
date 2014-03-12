Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaCLT3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:29:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40497 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaCLT3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:29:12 -0400
Date: Wed, 12 Mar 2014 15:29:10 -0400 (EDT)
Message-Id: <20140312.152910.2161353215312957612.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 8/9] lg-vl600: Convert uses of
 __constant_<foo> to <foo>
From: David Miller <davem@davemloft.net>
In-Reply-To: <90c51467c9cc8ca3b8e4d74a63da42b28d8d51ec.1394644825.git.joe@perches.com>
References: <cover.1394644825.git.joe@perches.com>
	<90c51467c9cc8ca3b8e4d74a63da42b28d8d51ec.1394644825.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Mar 2014 12:29:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 12 Mar 2014 10:22:37 -0700

> The use of __constant_<foo> has been unnecessary for quite awhile now.
> 
> Make these uses consistent with the rest of the kernel.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
