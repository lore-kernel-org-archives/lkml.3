Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbaEGOWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:22:34 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:44723 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932698AbaEGOWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:22:33 -0400
Date: Wed, 7 May 2014 09:22:31 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2 02/10] slab: makes clear_obj_pfmemalloc() just return
 masked value
In-Reply-To: <1399442780-28748-3-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.10.1405070922150.12543@gentwo.org>
References: <1399442780-28748-1-git-send-email-iamjoonsoo.kim@lge.com> <1399442780-28748-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Joonsoo Kim wrote:

> clear_obj_pfmemalloc() takes the pointer to pointer to store masked value
> back into this address. But this is useless, since we don't use this stored
> value anymore. All we need is just masked value so makes clear_obj_pfmemalloc()
> just return masked value.

Acked-by: Christoph Lameter <cl@linux.com>
