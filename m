Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbaJ1G24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:28:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510AbaJ1G2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 02:28:53 -0400
Date: Mon, 27 Oct 2014 23:29:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 dma-mapping tree
Message-Id: <20141027232910.952850f8.akpm@linux-foundation.org>
In-Reply-To: <20141028152444.79bd9fe9@canb.auug.org.au>
References: <20141028152444.79bd9fe9@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 15:24:44 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the akpm-current tree got a conflict in
> mm/cma.c between commit 16195ddd4ebc ("mm: cma: Ensure that
> reservations never cross the low/high mem boundary") from the
> dma-mapping tree and commit 2a70e5a78672 ("mm/cma: ake kmemleak ignore
> CMA regions") from the akpm-current tree.

hm, we have multiple trees altering mm/cma.c?

I'm a bit surprised that this series was merged, given that Laurent
said he would be sending out a v2...
