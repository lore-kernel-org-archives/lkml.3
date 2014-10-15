Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaJOS3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:29:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53222 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaJOS3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:29:35 -0400
Date: Wed, 15 Oct 2014 14:27:58 -0400 (EDT)
Message-Id: <20141015.142758.1663495852272800188.davem@davemloft.net>
To: himangi774@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] Drivers: ide: Remove typedef atiixp_ide_timing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140814164430.GA4237@himangi-Dell>
References: <20140814164430.GA4237@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Oct 2014 11:29:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Thu, 14 Aug 2014 22:14:30 +0530

> The Linux kernel coding style guidelines suggest not using typedefs
> for structure types. This patch gets rid of the typedef for
> atiixp_ide_timing.
> 
> The following Coccinelle semantic patch detects the case:
  ...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied, thanks.
