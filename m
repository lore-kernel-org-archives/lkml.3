Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3KATQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:16:42 -0400
Received: from a14-6.smtp-out.amazonses.com ([54.240.14.6]:42253 "EHLO
	a14-6.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086Ab3KATQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:16:41 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Nov 2013 15:16:40 EDT
Date: Fri, 1 Nov 2013 19:09:47 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 17/15] slab: replace non-existing 'struct freelist *'
 with 'void *'
In-Reply-To: <1383127441-30563-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <0000014215124298-73ed0d4f-b9ff-4645-87de-87a60abe4dc2-000000@email.amazonses.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com> <1383127441-30563-1-git-send-email-iamjoonsoo.kim@lge.com> <1383127441-30563-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.11.01-54.240.14.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013, Joonsoo Kim wrote:

> There is no 'strcut freelist', but codes use pointer to 'struct freelist'.
> Although compiler doesn't complain anything about this wrong usage and
> codes work fine, but fixing it is better.

I think its better to avoid "void" when possible. struct freelist is good.

