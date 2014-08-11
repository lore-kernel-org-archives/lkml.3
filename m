Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaHKTUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:20:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58314 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaHKTUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:20:46 -0400
Date: Mon, 11 Aug 2014 12:20:45 -0700 (PDT)
Message-Id: <20140811.122045.1648179759087421559.davem@davemloft.net>
To: himangi774@gmail.com
Cc: khc@pm.waw.pl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] hdlc: Remove typedefs from struct names
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140809164716.GA21548@himangi-Dell>
References: <20140809164716.GA21548@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Aug 2014 12:20:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Sat, 9 Aug 2014 22:17:16 +0530

> The Linux kernel coding style guidelines suggest not using typedefs
> for structure types. This patch gets rid of the typedefs for
> fr_hdr and pvc_device. Also, the names of the structs are changed to
> drop the _t, to make the name look less typedef-like.
> 
> The following Coccinelle semantic patch detects the case fr_hdr and a
> similar one detects the case for pvc_device.
 ...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied.
