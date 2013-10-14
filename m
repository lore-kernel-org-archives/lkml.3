Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab3JNOnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:43:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54915 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036Ab3JNOnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:43:49 -0400
Message-ID: <525C0307.7020802@ti.com>
Date: Mon, 14 Oct 2013 10:43:19 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <yinghai@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 09/23] mm/init: Use memblock apis for early memory allocations
References: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com> <1381615146-20342-10-git-send-email-santosh.shilimkar@ti.com> <20131013195406.GC18075@htj.dyndns.org>
In-Reply-To: <20131013195406.GC18075@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 October 2013 03:54 PM, Tejun Heo wrote:
> On Sat, Oct 12, 2013 at 05:58:52PM -0400, Santosh Shilimkar wrote:
>> Switch to memblock interfaces for early memory allocator
> 
> When posting actual (non-RFC) patches later, please cc the maintainers
> of the target subsystem and briefly explain why the new interface is
> needed and that this doesn't change visible behavior.
> 
Sure. Thanks a lot for quick response on the series. I will give another
week or so to see if there are more comments and then start addressing
comments in next version.

Regards,
Santosh

