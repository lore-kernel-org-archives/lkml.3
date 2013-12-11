Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3LKWMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:12:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3LKWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:10:49 -0500
Date: Wed, 11 Dec 2013 14:10:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: <santosh.shilimkar@ti.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mm/memblock: print phys_addr_t using %pa
Message-Id: <20131211141040.6a28d2f9173cab62727c8c9f@linux-foundation.org>
In-Reply-To: <1386776175-23779-2-git-send-email-grygorii.strashko@ti.com>
References: <1386776175-23779-1-git-send-email-grygorii.strashko@ti.com>
	<1386776175-23779-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 17:36:14 +0200 Grygorii Strashko <grygorii.strashko@ti.com> wrote:

> printk supports %pa format specifier to print phys_addr_t type values,
> so use it instead of %#010llx/0x%llx/0x%08lx and drop corresponding
> type casting.

This one needed some rework due to
http://ozlabs.org/~akpm/mmots/broken-out/memblock-numa-introduce-flags-field-into-memblock.patch,
but it was all pretty simple.

