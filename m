Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbaEGOVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:21:44 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:51082 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932812AbaEGOVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:21:43 -0400
Date: Wed, 7 May 2014 09:21:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2 01/10] slab: add unlikely macro to help compiler
In-Reply-To: <1399442780-28748-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.10.1405070921280.12543@gentwo.org>
References: <1399442780-28748-1-git-send-email-iamjoonsoo.kim@lge.com> <1399442780-28748-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Joonsoo Kim wrote:

> slab_should_failslab() is called on every allocation, so to optimize it
> is reasonable. We normally don't allocate from kmem_cache. It is just
> used when new kmem_cache is created, so it's very rare case. Therefore,
> add unlikely macro to help compiler optimization.

Acked-by: Christoph Lameter <cl@linux.com>
