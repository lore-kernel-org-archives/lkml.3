Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaHNPC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:02:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33836 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbaHNPCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:02:24 -0400
Message-ID: <53ECCF7E.2090305@infradead.org>
Date: Thu, 14 Aug 2014 08:02:22 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Aug 14 (mm/memory_hotplug.c and drivers/base/memory.c)
References: <20140814152749.24d43663@canb.auug.org.au>
In-Reply-To: <20140814152749.24d43663@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/14 22:27, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add code intended for v3.18 until after v3.17-rc1 is
> released.
> 
> Changes since 20140813:
> 

on x86_64:

drivers/built-in.o: In function `show_zones_online_to':
memory.c:(.text+0x13f306): undefined reference to `test_pages_in_a_zone'

in drivers/base/memory.c

when CONFIG_MEMORY_HOTREMOVE is not enabled.

The function implementation in mm/memory_hotplug.c is only built if
CONFIG_MEMORY_HOTREMOVE is enabled.


-- 
~Randy
