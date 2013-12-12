Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3LLRhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:37:13 -0500
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:56571 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674Ab3LLRhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:37:11 -0500
Date: Thu, 12 Dec 2013 17:37:10 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Hansen <dave@sr71.net>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] mm: slab: separate slab_page from 'struct page'
In-Reply-To: <52A793D0.4020306@sr71.net>
Message-ID: <00000142e7e23135-20f346b1-a880-47b0-946c-122323669ec1-000000@email.amazonses.com>
References: <20131210204641.3CB515AE@viggo.jf.intel.com> <00000142de5634af-f92870a7-efe2-45cd-b50d-a6fbdf3b353c-000000@email.amazonses.com> <52A78B55.8050500@sr71.net> <00000142de866123-cf1406b5-b7a3-4688-b46f-80e338a622a1-000000@email.amazonses.com>
 <52A793D0.4020306@sr71.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.12-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Dave Hansen wrote:

> See? *EVERYTHING* is overridden by at least one of the sl?b allocators
> except ->flags.  In other words, there *ARE* no relationships when it
> comes to the sl?bs, except for page->flags.

Slab objects can be used for I/O and then the page fields become
important.

