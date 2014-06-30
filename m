Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaF3PtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:49:08 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:35045 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbaF3PtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:49:07 -0400
Date: Mon, 30 Jun 2014 10:49:03 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Vladimir Davydov <vdavydov@parallels.com>, akpm@linux-foundation.org,
        rientjes@google.com, penberg@kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v3 8/8] slab: do not keep free objects/slabs on dead
 memcg caches
In-Reply-To: <20140627060534.GC9511@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.11.1406301048070.19422@gentwo.org>
References: <cover.1402602126.git.vdavydov@parallels.com> <a985aec824cd35df381692fca83f7a8debc80305.1402602126.git.vdavydov@parallels.com> <20140624073840.GC4836@js1304-P5Q-DELUXE> <20140625134545.GB22340@esperanza>
 <20140627060534.GC9511@js1304-P5Q-DELUXE>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014, Joonsoo Kim wrote:

> Christoph,
> Is it tolerable result for large scale system? Or do we need to find
> another solution?


The overhead is pretty intense but then this is a rare event I guess?

It seems that it is much easier on the code and much faster to do the
periodic reaping. Why not simply go with that?


