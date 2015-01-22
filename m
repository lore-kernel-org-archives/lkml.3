Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbbAVQO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:14:57 -0500
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:52758 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801AbbAVQOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:14:50 -0500
Date: Thu, 22 Jan 2015 10:14:48 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michal Hocko <mhocko@suse.cz>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmotm: mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
 is causing preemptible splats
In-Reply-To: <20150121132308.GB23700@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.11.1501221014110.3937@gentwo.org>
References: <20150121132308.GB23700@dhcp22.suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I am not sure how to fix this but it sounds like this_cpu_ptr should
> offer the same preempt expectations as other this_cpu_* functions.

One returns a pointer that may not be useful if the context is switched
and the other completes a operationo on an opject.

