Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3AWPZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:25:52 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:35796 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783Ab3AWPZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:25:51 -0500
Date: Wed, 23 Jan 2013 15:25:50 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, js1304@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] slub: correct bootstrap() for kmem_cache,
 kmem_cache_node
In-Reply-To: <1358755287-3899-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <0000013c6803dc46-c69428be-b537-4513-914d-88b58e63dcc4-000000@email.amazonses.com>
References: <1358755287-3899-1-git-send-email-iamjoonsoo.kim@lge.com> <1358755287-3899-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013, Joonsoo Kim wrote:

> v2: don't loop over all processors in bootstrap().

Acked-by: Christoph Lameter <cl@linux.com>
