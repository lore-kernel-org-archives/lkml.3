Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3HKFsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 01:48:22 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:27305 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab3HKFsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 01:48:20 -0400
X-IronPort-AV: E=Sophos;i="4.89,855,1367964000"; 
   d="scan'208";a="29032756"
Date: Sun, 11 Aug 2013 07:48:18 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Jonathan Cameron <jic23@cam.ac.uk>,
        kernel-janitors@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/mach-pxa/stargate2.c: use ARRAY_AND_SIZE
 consistently
In-Reply-To: <20130810223338.GM5502@mwanda>
Message-ID: <alpine.DEB.2.02.1308110745030.2072@localhost6.localdomain6>
References: <1376148353-9699-1-git-send-email-Julia.Lawall@lip6.fr> <20130810223338.GM5502@mwanda>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Aug 2013, Dan Carpenter wrote:

> ARRAY_AND_SIZE() macro is horrible, and I would like it if it were
> removed.  What I meant before was just that probably people will
> probably complain if we try to remove it.

Well, I could either wait for someone to defend it, or send a patch 
getting rid of it and see what happens...  I can't see what could go wrong 
with

f(...,
- ARRAY_AND_SIZE(e)
+ e, ARRAY_SIZE(e)
  , ...)

so it should be an easy patch to create.

julia
