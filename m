Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967153AbaFRO0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:26:52 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:43435 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966809AbaFRO0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:26:49 -0400
Date: Wed, 18 Jun 2014 09:26:46 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: slab.h: wrap the whole file with guarding macro
In-Reply-To: <1403100695-1350-1-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.11.1406180926310.28208@gentwo.org>
References: <1403100695-1350-1-git-send-email-a.ryabinin@samsung.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Andrey Ryabinin wrote:

> Guarding section:
> 	#ifndef MM_SLAB_H
> 	#define MM_SLAB_H
> 	...
> 	#endif
> currently doesn't cover the whole mm/slab.h. It seems like it was
> done unintentionally.
>
> Wrap the whole file by moving closing #endif to the end of it.

Acked-by: Christoph Lameter <cl@linux.com>
