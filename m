Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3GCNzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:55:23 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:35268 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755367Ab3GCNzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:55:21 -0400
Date: Wed, 3 Jul 2013 13:55:20 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] mm/slab: Fix /proc/slabinfo unwriteable for
 slab
In-Reply-To: <1372812593-7617-3-git-send-email-liwanp@linux.vnet.ibm.com>
Message-ID: <0000013fa4d0e060-54cc0d26-3ddf-48bb-a868-1fb5b41ea5fb-000000@email.amazonses.com>
References: <1372812593-7617-1-git-send-email-liwanp@linux.vnet.ibm.com> <1372812593-7617-3-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.03-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jul 2013, Wanpeng Li wrote:

> Slab have some tunables like limit, batchcount, and sharedfactor can be
> tuned through function slabinfo_write. Commit (b7454ad3: mm/sl[au]b: Move
> slabinfo processing to slab_common.c) uncorrectly change /proc/slabinfo
> unwriteable for slab, this patch fix it by revert to original mode.

Acked-by: Christoph Lameter <cl@linux.com>
