Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab3LJAkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:40:19 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53061 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3LJAkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:40:13 -0500
Message-ID: <52A662D2.9010201@ti.com>
Date: Mon, 9 Dec 2013 19:39:46 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mm: nobootmem: avoid type warning about alignment value
References: <1385249326-9089-1-git-send-email-santosh.shilimkar@ti.com> <529217C7.6030304@cogentembedded.com> <52935762.1080409@ti.com> <20131125155629.GA24344@htj.dyndns.org>
In-Reply-To: <20131125155629.GA24344@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Monday 25 November 2013 10:56 AM, Tejun Heo wrote:
> On Mon, Nov 25, 2013 at 08:57:54AM -0500, Santosh Shilimkar wrote:
>> On Sunday 24 November 2013 10:14 AM, Sergei Shtylyov wrote:
>>> Hello.
>>>
>>> On 24-11-2013 3:28, Santosh Shilimkar wrote:
>>>
>>>> Building ARM with NO_BOOTMEM generates below warning. Using min_t
>>>
>>>    Where is that below? :-)
>>>
>> Damn.. Posted a wrong version of the patch ;-(
>> Here is the one with warning message included.
>>
>> From 571dfdf4cf8ac7dfd50bd9b7519717c42824f1c3 Mon Sep 17 00:00:00 2001
>> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Date: Sat, 23 Nov 2013 18:16:50 -0500
>> Subject: [PATCH] mm: nobootmem: avoid type warning about alignment value
>>
>> Building ARM with NO_BOOTMEM generates below warning.
>>
>> mm/nobootmem.c: In function ‘__free_pages_memory’:
>> mm/nobootmem.c:88:11: warning: comparison of distinct pointer types lacks a cast
>>
>> Using min_t to find the correct alignment avoids the warning.
>>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
Can you please this warning fix as well in your mm tree ?

Regards,
Santosh
