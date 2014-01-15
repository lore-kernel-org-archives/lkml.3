Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaAOHQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:16:35 -0500
Received: from mail-gg0-f169.google.com ([209.85.161.169]:61265 "EHLO
	mail-gg0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaAOHQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:16:29 -0500
Date: Tue, 14 Jan 2014 23:16:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/9] mm: slab/slub: use page->list consistently
 instead of page->lru
In-Reply-To: <52D63192.3080306@sr71.net>
Message-ID: <alpine.DEB.2.02.1401142316090.19933@chino.kir.corp.google.com>
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180044.1E401C47@viggo.jf.intel.com> <alpine.DEB.2.02.1401141829530.32645@chino.kir.corp.google.com> <52D63192.3080306@sr71.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-478612926-1389770188=:19933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-478612926-1389770188=:19933
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 14 Jan 2014, Dave Hansen wrote:

> > block/blk-mq.c: In function ‘blk_mq_free_rq_map’:
> > block/blk-mq.c:1094:10: error: ‘struct page’ has no member named ‘list’
> > block/blk-mq.c:1094:10: warning: initialization from incompatible pointer type [enabled by default]
> > block/blk-mq.c:1094:10: error: ‘struct page’ has no member named ‘list’
> > block/blk-mq.c:1095:22: error: ‘struct page’ has no member named ‘list’
> > block/blk-mq.c: In function ‘blk_mq_init_rq_map’:
> > block/blk-mq.c:1159:22: error: ‘struct page’ has no member named ‘list’
> 
> As I mentioned in the introduction, these are against linux-next.
> There's a patch in there at the moment which fixed this.
> 

Ok, thanks, I like this patch.

Acked-by: David Rientjes <rientjes@google.com>
--531381512-478612926-1389770188=:19933--
