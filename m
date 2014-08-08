Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbaHHOpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:45:01 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:49007 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704AbaHHOpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:45:00 -0400
Date: Fri, 8 Aug 2014 09:44:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH for v3.17-rc1] Revert "slab: remove BAD_ALIEN_MAGIC"
In-Reply-To: <1407481239-7572-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.11.1408080943280.16459@gentwo.org>
References: <1407481239-7572-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014, Joonsoo Kim wrote:

> This reverts commit a640616822b2 ("slab: remove BAD_ALIEN_MAGIC").

Lets hold off on this one. I am bit confused as to why a non NUMA system
would have multiple NUMA nodes.

