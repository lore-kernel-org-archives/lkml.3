Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762325Ab3JQTDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:03:32 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:56263 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758233Ab3JQTDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:03:31 -0400
Date: Thu, 17 Oct 2013 19:03:29 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/5] slab: factor out calculate nr objects in
 cache_estimate
In-Reply-To: <1381989797-29269-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000141c7cd1ab4-314fa179-ada6-4682-95a3-09228d38adf7-000000@email.amazonses.com>
References: <1381989797-29269-1-git-send-email-iamjoonsoo.kim@lge.com> <1381989797-29269-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.17-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, Joonsoo Kim wrote:

> This logic is not simple to understand so that making separate function
> helping readability. Additionally, we can use this change in the
> following patch which implement for freelist to have another sized index
> in according to nr objects.

Acked-by: Christoph Lameter <cl@linux.com>
