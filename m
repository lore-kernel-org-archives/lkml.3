Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab3LDO6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:58:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39182 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257Ab3LDO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:58:35 -0500
Message-ID: <529F42FD.5020704@ti.com>
Date: Wed, 4 Dec 2013 09:58:05 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mm@kvack.org>, Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 02/23] mm/memblock: debug: don't free reserved array
 if !ARCH_DISCARD_MEMBLOCK
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com> <1386037658-3161-3-git-send-email-santosh.shilimkar@ti.com> <20131203225258.GS8277@htj.dyndns.org>
In-Reply-To: <20131203225258.GS8277@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 December 2013 05:52 PM, Tejun Heo wrote:
> On Mon, Dec 02, 2013 at 09:27:17PM -0500, Santosh Shilimkar wrote:
> ...
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Reviewed-by: Tejun Heo <tj@kernel.org>
> 
>> +	/*
>> +	 * Don't allow Nobootmem allocator to free reserved memory regions
> 
> Extreme nitpick: why the capitalization of "Nobootmem"?
> 
Will fix that

