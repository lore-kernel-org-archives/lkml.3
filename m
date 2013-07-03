Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab3GCNy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:54:57 -0400
Received: from a10-63.smtp-out.amazonses.com ([54.240.10.63]:53419 "EHLO
	a10-63.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252Ab3GCNy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:54:56 -0400
Date: Wed, 3 Jul 2013 13:54:55 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] mm/slab: Sharing s_next and s_stop between slab
 and slub
In-Reply-To: <1372812593-7617-2-git-send-email-liwanp@linux.vnet.ibm.com>
Message-ID: <0000013fa4d07db3-dc4ef0e6-3557-4bf3-be40-39cdf1060253-000000@email.amazonses.com>
References: <1372812593-7617-1-git-send-email-liwanp@linux.vnet.ibm.com> <1372812593-7617-2-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.03-54.240.10.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jul 2013, Wanpeng Li wrote:

> This patch shares s_next and s_stop between slab and slub.

Acked-by: Christoph Lameter <cl@linux.com>
