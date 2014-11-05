Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaKESmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:42:12 -0500
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:39928 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbaKESmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:42:09 -0500
Date: Wed, 5 Nov 2014 12:42:05 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 7/8] slab: introduce slab_free helper
In-Reply-To: <439ae0a228e18af4ba909dce471a7e3d21005ef6.1415046910.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1411051241330.28485@gentwo.org>
References: <cover.1415046910.git.vdavydov@parallels.com> <439ae0a228e18af4ba909dce471a7e3d21005ef6.1415046910.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some comments would be good for the commit.

Acked-by: Christoph Lameter <cl@linux.com>
