Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab3GENha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:37:30 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:36336 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751578Ab3GENh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:37:29 -0400
Date: Fri, 5 Jul 2013 13:37:28 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mm/slab: Fix drain freelist excessively
In-Reply-To: <1372898006-6308-1-git-send-email-liwanp@linux.vnet.ibm.com>
Message-ID: <0000013faf0d3958-00e5e945-25d8-43c1-ac6e-3d3ad69b2718-000000@email.amazonses.com>
References: <1372898006-6308-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.05-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jul 2013, Wanpeng Li wrote:

> This patch fix the callers that pass # of objects. Make sure they pass #
> of slabs.

Acked-by: Christoph Lameter <cl@linux.com>
