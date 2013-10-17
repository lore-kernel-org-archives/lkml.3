Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762354Ab3JQTF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:05:56 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:39859 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758559Ab3JQTF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:05:56 -0400
Date: Thu, 17 Oct 2013 19:05:54 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 04/15] slab: remove nodeid in struct slab
In-Reply-To: <1381913052-23875-5-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000141c7cf516e-9c81134b-35e0-4e75-90f2-e7706c28a9d4-000000@email.amazonses.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com> <1381913052-23875-5-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Joonsoo Kim wrote:

> We can get nodeid using address translation, so this field is not useful.
> Therefore, remove it.

Acked-by: Christoph Lameter <cl@linux.com>
