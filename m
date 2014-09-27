Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaI0Pxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 11:53:49 -0400
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:46978 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbaI0Pxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 11:53:48 -0400
Date: Sat, 27 Sep 2014 10:53:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Paul Bolle <pebolle@tiscali.nl>
cc: Johannes Weiner <hannes@cmpxchg.org>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: use IS_ENABLED() instead of ZONE_DMA_FLAG
In-Reply-To: <1411811803.15241.50.camel@x220>
Message-ID: <alpine.DEB.2.11.1409271053170.22114@gentwo.org>
References: <1411667851.2020.6.camel@x41> <20140925185047.GA21089@cmpxchg.org> <1411811803.15241.50.camel@x220>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Sep 2014, Paul Bolle wrote:

> Do your comments require the patch to be redone (partially or entirely)?
> In that case someone else should probably take it and improve it, as I
> hardly understand the issues you raise. Or is the patch already queued
> somewhere, with Cristoph's Ack attached?

Please respin the patch taking Johannes feedback into consideration.

