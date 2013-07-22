Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab3GVFBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 01:01:18 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:42227 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab3GVFBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 01:01:17 -0400
Date: Mon, 22 Jul 2013 05:01:16 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, cesarb@cesarb.net,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 02/18] MAINTAINERS: ARM: OMAP2/3: Remove unused clockdomain
 files
In-Reply-To: <0de56f7acdc9ed7aced4a78000c0ec7e0f70c011.1374451988.git.joe@perches.com>
Message-ID: <alpine.DEB.2.02.1307220459020.4804@utopia.booyaka.com>
References: <cover.1374451988.git.joe@perches.com> <0de56f7acdc9ed7aced4a78000c0ec7e0f70c011.1374451988.git.joe@perches.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jul 2013, Joe Perches wrote:

> commit 4bd5259e53a ("ARM: OMAP2/3: clockdomain/PRM/CM: move the
> low-level clockdomain functions into PRM/CM") deleted the files,
> update the pattern.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Paul Walmsley <paul@pwsan.com>
> cc: Rajendra Nayak <rnayak@ti.com>
> cc: Santosh Shilimkar <santosh.shilimkar@ti.com>

I don't object to the content of this patch, but Cesar 
Eduardo Barros posted a patch for this already (and cc'ed you) back 
in March:

http://lkml.indiana.edu/hypermail/linux/kernel/1303.0/00904.html

Please take his patch instead, or credit him in your patch.


- Paul
