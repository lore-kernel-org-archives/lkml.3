Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3JMTyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 15:54:11 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64200 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab3JMTyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 15:54:10 -0400
Date: Sun, 13 Oct 2013 15:54:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: yinghai@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        grygorii.strashko@ti.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 09/23] mm/init: Use memblock apis for early memory
 allocations
Message-ID: <20131013195406.GC18075@htj.dyndns.org>
References: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
 <1381615146-20342-10-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381615146-20342-10-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 05:58:52PM -0400, Santosh Shilimkar wrote:
> Switch to memblock interfaces for early memory allocator

When posting actual (non-RFC) patches later, please cc the maintainers
of the target subsystem and briefly explain why the new interface is
needed and that this doesn't change visible behavior.

Thanks.

-- 
tejun
