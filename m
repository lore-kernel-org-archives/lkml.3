Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3APPFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:05:12 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:44450 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688Ab3APPFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:05:10 -0500
Date: Wed, 16 Jan 2013 15:05:07 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] slub: correct bootstrap() for kmem_cache,
 kmem_cache_node
In-Reply-To: <20130116084459.GB13446@lge.com>
Message-ID: <0000013c43e46737-a6429216-478b-4cac-b618-447bf003a063-000000@email.amazonses.com>
References: <1358234402-2615-1-git-send-email-iamjoonsoo.kim@lge.com> <1358234402-2615-2-git-send-email-iamjoonsoo.kim@lge.com> <0000013c3eda78d8-da8c775c-d7c0-4a88-bacf-0b5160b5c668-000000@email.amazonses.com> <20130116084459.GB13446@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013, Joonsoo Kim wrote:

> These slabs are not on the partial list, but on the cpu_slab of boot cpu.

> Reason for this is described in changelog.
> Because these slabs are not on partial list, we need to
> check kmem_cache_cpu's cpu slab. This patch implement it.

Ah. Ok.
