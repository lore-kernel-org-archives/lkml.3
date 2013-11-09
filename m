Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab3KITJf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 14:09:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36329 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab3KITJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 14:09:32 -0500
Message-ID: <527E8848.6030307@ti.com>
Date: Sat, 9 Nov 2013 14:08:56 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <tj@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 13/24] mm/power: Use memblock apis for early memory allocations
References: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com> <1383954120-24368-14-git-send-email-santosh.shilimkar@ti.com> <1479529.EjZ9YN8f8I@vostro.rjw.lan>
In-Reply-To: <1479529.EjZ9YN8f8I@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 November 2013 08:30 PM, Rafael J. Wysocki wrote:
> On Friday, November 08, 2013 06:41:49 PM Santosh Shilimkar wrote:
>> Switch to memblock interfaces for early memory allocator instead of
>> bootmem allocator. No functional change in beahvior than what it is
>> in current code from bootmem users points of view.
>>
>> Archs already converted to NO_BOOTMEM now directly use memblock
>> interfaces instead of bootmem wrappers build on top of memblock. And the
>> archs which still uses bootmem, these new apis just fallback to exiting
>> bootmem APIs.
>>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Pavel Machek <pavel@ucw.cz>
>> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>> Cc: linux-pm@vger.kernel.org
>>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Fine by me, thanks!
> 
Thanks Rafael. I take that as an ack.

Regards,
Santosh

