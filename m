Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaEVAPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:15:30 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:56443 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717AbaEVAP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:15:29 -0400
Date: Wed, 21 May 2014 19:15:26 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC 3/3] slub: reparent memcg caches' slabs on memcg
 offline
In-Reply-To: <20140521151423.GC23193@esperanza>
Message-ID: <alpine.DEB.2.10.1405211913350.4433@gentwo.org>
References: <alpine.DEB.2.10.1405141119320.16512@gentwo.org> <20140515071650.GB32113@esperanza> <alpine.DEB.2.10.1405151015330.24665@gentwo.org> <20140516132234.GF32113@esperanza> <alpine.DEB.2.10.1405160957100.32249@gentwo.org> <20140519152437.GB25889@esperanza>
 <alpine.DEB.2.10.1405191056580.22956@gentwo.org> <537A4D27.1050909@parallels.com> <20140521135826.GA23193@esperanza> <alpine.DEB.2.10.1405210944140.8038@gentwo.org> <20140521151423.GC23193@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014, Vladimir Davydov wrote:

> Don't think so. AFAIU put_cpu_partial() first checks if the per-cpu
> partial list has more than s->cpu_partial objects draining it if so, but
> then it adds the newly frozen slab there anyway.

Hmmm... Ok true. Maybe insert some code there then.

