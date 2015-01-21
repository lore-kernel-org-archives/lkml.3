Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbbAUOLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:11:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbbAUOLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:11:40 -0500
Date: Wed, 21 Jan 2015 15:11:38 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Krzysztof =?utf-8?Q?Koz=C5=82owski?= <k.kozlowski.k@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmotm:
 mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch is
 causing preemptible splats
Message-ID: <20150121141138.GC23700@dhcp22.suse.cz>
References: <20150121132308.GB23700@dhcp22.suse.cz>
 <CAJKOXPdgSsd8cr7ctKOGCwFTRMxcq71k7Pb5mQgYy--tGW8+_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJKOXPdgSsd8cr7ctKOGCwFTRMxcq71k7Pb5mQgYy--tGW8+_w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 21-01-15 15:06:03, Krzysztof Kozłowski wrote:
[...]
> Same here :) [1] . So actually only ARM seems affected (both armv7 and
> armv8) because it is the only one which uses smp_processor_id() in
> my_cpu_offset.

This was on x86_64 with CONFIG_DEBUG_PREEMPT so it is not only ARM
specific.
 
> [1] https://lkml.org/lkml/2015/1/20/162

Sorry, have missed this post.
-- 
Michal Hocko
SUSE Labs
