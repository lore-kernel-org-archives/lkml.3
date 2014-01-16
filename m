Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbaAPRlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:41:32 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:35248 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaAPRla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:41:30 -0500
Date: Thu, 16 Jan 2014 18:41:21 +0100
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: Robin Holt <robinmholt@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, liuj97@gmail.com,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        iamjoonsoo.kim@lge.com, robin.m.holt@gmail.com, yinghai@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/nobootmem: Fix unused variable
Message-ID: <20140116184121.34d1e97c@lilie>
In-Reply-To: <CAPp3RGpt+qjFYrA928hBjseJNo4v0RKVnb-BjFJzH0uaVGcX+g@mail.gmail.com>
References: <1389879186-43649-1-git-send-email-phacht@linux.vnet.ibm.com>
	<CAPp3RGpWhx4uoTTiSkUe9rZ2iJjMW6O2u=xdWL7BSskse=61qw@mail.gmail.com>
	<20140116164936.1c6c3274@lilie>
	<CAPp3RGpt+qjFYrA928hBjseJNo4v0RKVnb-BjFJzH0uaVGcX+g@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011617-4966-0000-0000-000008172F24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I would think you would be better off making
> get_allocated_memblock_reserved_regions_info() and
> get_allocated_memblock_memory_regions_info be static inline functions
> when #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK.
Possible, of course.
But the size variable has still to be #ifdef'd. And that's what the
patch is about. It's just an addition to another patch. 


