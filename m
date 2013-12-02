Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3LBTpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:45:31 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:44760 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235Ab3LBTp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:45:27 -0500
Date: Mon, 2 Dec 2013 19:45:25 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v3 3/5] slab: restrict the number of objects in a slab
In-Reply-To: <1385974183-31423-4-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000142b4d806ec-106a9e18-afdc-404a-8aa0-4f09cfa743e8-000000@email.amazonses.com>
References: <1385974183-31423-1-git-send-email-iamjoonsoo.kim@lge.com> <1385974183-31423-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013, Joonsoo Kim wrote:

> If page size is rather larger than 4096, above assumption would be wrong.
> In this case, we would fall back on 2 bytes sized index.

Acked-by: Christoph Lameter <cl@linux.com>

