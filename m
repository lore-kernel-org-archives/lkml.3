Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaFBPRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:17:36 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:38288
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493AbaFBPRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:17:35 -0400
Date: Mon, 2 Jun 2014 10:17:32 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Joonsoo Kim <js1304@gmail.com>
cc: Vladimir Davydov <vdavydov@parallels.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH -mm 7/8] slub: make dead caches discard free slabs
 immediately
In-Reply-To: <CAAmzW4P=kUAJwozBPPos+uUewzSDnE43P6NcGYKNpBjjfv1EWA@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406021017141.2987@gentwo.org>
References: <cover.1401457502.git.vdavydov@parallels.com> <5d2fbc894a2c62597e7196bb1ebb8357b15529ab.1401457502.git.vdavydov@parallels.com> <alpine.DEB.2.10.1405300955120.11943@gentwo.org> <20140531110456.GC25076@esperanza> <20140602042435.GA17964@js1304-P5Q-DELUXE>
 <20140602114741.GA1039@esperanza> <CAAmzW4P=kUAJwozBPPos+uUewzSDnE43P6NcGYKNpBjjfv1EWA@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014, Joonsoo Kim wrote:

> Hmm... this is also a bit ugly.
> How about following change?

That looks much cleaner.
