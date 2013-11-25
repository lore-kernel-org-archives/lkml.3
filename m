Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3KYP4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:56:39 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:59746 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3KYP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:56:37 -0500
Date: Mon, 25 Nov 2013 10:56:29 -0500
From: Tejun Heo <tj@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mm: nobootmem: avoid type warning about alignment value
Message-ID: <20131125155629.GA24344@htj.dyndns.org>
References: <1385249326-9089-1-git-send-email-santosh.shilimkar@ti.com>
 <529217C7.6030304@cogentembedded.com>
 <52935762.1080409@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52935762.1080409@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 08:57:54AM -0500, Santosh Shilimkar wrote:
> On Sunday 24 November 2013 10:14 AM, Sergei Shtylyov wrote:
> > Hello.
> > 
> > On 24-11-2013 3:28, Santosh Shilimkar wrote:
> > 
> >> Building ARM with NO_BOOTMEM generates below warning. Using min_t
> > 
> >    Where is that below? :-)
> > 
> Damn.. Posted a wrong version of the patch ;-(
> Here is the one with warning message included.
> 
> From 571dfdf4cf8ac7dfd50bd9b7519717c42824f1c3 Mon Sep 17 00:00:00 2001
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date: Sat, 23 Nov 2013 18:16:50 -0500
> Subject: [PATCH] mm: nobootmem: avoid type warning about alignment value
> 
> Building ARM with NO_BOOTMEM generates below warning.
> 
> mm/nobootmem.c: In function ‘__free_pages_memory’:
> mm/nobootmem.c:88:11: warning: comparison of distinct pointer types lacks a cast
> 
> Using min_t to find the correct alignment avoids the warning.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
