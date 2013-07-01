Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3GAPsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:48:24 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:51339 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099Ab3GAPsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:48:11 -0400
Date: Mon, 1 Jul 2013 15:48:09 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/slab: Sharing s_next and s_stop between slab and
 slub
In-Reply-To: <alpine.DEB.2.02.1306241421560.25343@chino.kir.corp.google.com>
Message-ID: <0000013f9aeb70c6-f6dad22c-bb88-4313-8602-538a3f5cedf5-000000@email.amazonses.com>
References: <1372069394-26167-1-git-send-email-liwanp@linux.vnet.ibm.com> <1372069394-26167-2-git-send-email-liwanp@linux.vnet.ibm.com> <alpine.DEB.2.02.1306241421560.25343@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.01-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, David Rientjes wrote:

> On Mon, 24 Jun 2013, Wanpeng Li wrote:
>
> > This patch shares s_next and s_stop between slab and slub.
> >
>
> Just about the entire kernel includes slab.h, so I think you'll need to
> give these slab-specific names instead of exporting "s_next" and "s_stop"
> to everybody.

He put the export into mm/slab.h. The headerfile is only included by
mm/sl?b.c .
