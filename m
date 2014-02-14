Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaBNSrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:47:25 -0500
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:38424
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbaBNSrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:47:23 -0500
Date: Fri, 14 Feb 2014 12:47:21 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 7/9] slab: use the lock on alien_cache, instead of the
 lock on array_cache
In-Reply-To: <1392361043-22420-8-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.10.1402141247070.12887@nuc>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com> <1392361043-22420-8-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Joonsoo Kim wrote:

> Now, we have separate alien_cache structure, so it'd be better to hold
> the lock on alien_cache while manipulating alien_cache. After that,
> we don't need the lock on array_cache, so remove it.

Acked-by: Christoph Lameter <cl@linux.com>
