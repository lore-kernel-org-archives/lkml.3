Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab3HBOtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:49:55 -0400
Received: from a10-63.smtp-out.amazonses.com ([54.240.10.63]:47364 "EHLO
	a10-63.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857Ab3HBOtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:49:53 -0400
Date: Fri, 2 Aug 2013 14:49:48 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH] mm, slab_common: add 'unlikely' to size check of
 kmalloc_slab()
In-Reply-To: <1375408962-16743-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <000001403f81890d-57137aa9-0063-4457-8647-32369c68814f-000000@email.amazonses.com>
References: <1375408962-16743-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.02-54.240.10.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Aug 2013, Joonsoo Kim wrote:

> Size is usually below than KMALLOC_MAX_SIZE.
> If we add a 'unlikely' macro, compiler can make better code.

Acked-by: Christoph Lameter <cl@linux.com>
