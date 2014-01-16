Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaAPQht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:37:49 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62137 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbaAPQho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:37:44 -0500
MIME-Version: 1.0
In-Reply-To: <20140116164936.1c6c3274@lilie>
References: <1389879186-43649-1-git-send-email-phacht@linux.vnet.ibm.com>
	<CAPp3RGpWhx4uoTTiSkUe9rZ2iJjMW6O2u=xdWL7BSskse=61qw@mail.gmail.com>
	<20140116164936.1c6c3274@lilie>
Date: Thu, 16 Jan 2014 10:37:43 -0600
Message-ID: <CAPp3RGpt+qjFYrA928hBjseJNo4v0RKVnb-BjFJzH0uaVGcX+g@mail.gmail.com>
Subject: Re: [PATCH] mm/nobootmem: Fix unused variable
From: Robin Holt <robinmholt@gmail.com>
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, liuj97@gmail.com,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        iamjoonsoo.kim@lge.com, robin.m.holt@gmail.com, yinghai@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since your patch set is the _ONLY_ thing that introduces #ifdef's
inside functions within
this file, I would think you would be better off making
get_allocated_memblock_reserved_regions_info() and
get_allocated_memblock_memory_regions_info be static inline functions
when #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK.

That said, I don't have a fundamental objection to #ifdef's inside
functions so...

Acked-by: Robin Holt <robinmholt@gmail.com>

On Thu, Jan 16, 2014 at 9:49 AM, Philipp Hachtmann
<phacht@linux.vnet.ibm.com> wrote:
> Hi Robin,
>
>>  Maybe you are working off a different repo than
>> Linus' latest?  Your line 116 is my 114.  Maybe the message needs to
>> be a bit more descriptive
>
> Ah, yes. This fits Andrew's linux-next.
>
> Regards
>
> Philipp
>
