Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3LLRkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:40:05 -0500
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:56784 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944Ab3LLRkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:40:01 -0500
Date: Thu, 12 Dec 2013 17:39:59 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Hansen <dave@sr71.net>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, Andi Kleen <ak@linux.intel.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/2] mm: slab/slub: use page->list consistently instead
 of page->lru
In-Reply-To: <20131211223631.51094A3D@viggo.jf.intel.com>
Message-ID: <00000142e7e4c89c-f8f8fab4-687c-4fe0-b0ac-c4b9ec25d739-000000@email.amazonses.com>
References: <20131211223631.51094A3D@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.12-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Dave Hansen wrote:

> 'struct page' has two list_head fields: 'lru' and 'list'.
> Conveniently, they are unioned together.  This means that code
> can use them interchangably, which gets horribly confusing like
> with this nugget from slab.c:

Acked-by: Christoph Lameter <cl@linux.com>
