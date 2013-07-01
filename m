Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3GAPvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:51:11 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:54732 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab3GAPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:51:10 -0400
Date: Mon, 1 Jul 2013 15:51:07 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        lllllinux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/slab: Fix /proc/slabinfo unwriteable for
 slab
In-Reply-To: <1372293700-15916-3-git-send-email-liwanp@linux.vnet.ibm.com>
Message-ID: <0000013f9aee2258-02568e26-df6e-4db6-abc5-1aa5f3998f73-000000@email.amazonses.com>
References: <1372293700-15916-1-git-send-email-liwanp@linux.vnet.ibm.com> <1372293700-15916-3-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.01-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, Wanpeng Li wrote:

> Slab have some tunables like limit, batchcount, and sharedfactor can be
> tuned through function slabinfo_write. Commit (b7454ad3: mm/sl[au]b: Move
> slabinfo processing to slab_common.c) uncorrectly change /proc/slabinfo
> unwriteable for slab, this patch fix it by revert to original mode.

See comment on V1.
