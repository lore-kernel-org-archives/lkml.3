Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3GCNyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:54:25 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:56275 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517Ab3GCNyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:54:24 -0400
Date: Wed, 3 Jul 2013 13:54:22 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] mm/slab: Fix drain freelist excessively
In-Reply-To: <1372812593-7617-1-git-send-email-liwanp@linux.vnet.ibm.com>
Message-ID: <0000013fa4cffd1e-e2977e3b-748a-4b7e-9ee6-669b41912abc-000000@email.amazonses.com>
References: <1372812593-7617-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.03-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jul 2013, Wanpeng Li wrote:

> This patch fix the callers that pass # of objects. Make sure they pass #
> of slabs.

Hmm... These modifications are all the same. Create a new function?

