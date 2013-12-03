Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3LCW6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:58:20 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:48651 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab3LCW6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:58:18 -0500
Date: Tue, 3 Dec 2013 17:58:15 -0500
From: Tejun Heo <tj@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 07/23] mm/memblock: drop WARN and use SMP_CACHE_BYTES
 as a default alignment
Message-ID: <20131203225815.GW8277@htj.dyndns.org>
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
 <1386037658-3161-8-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386037658-3161-8-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 09:27:22PM -0500, Santosh Shilimkar wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> drop WARN and use SMP_CACHE_BYTES as a default alignment in
> memblock_alloc_base_nid() as recommended by Tejun Heo in
> https://lkml.org/lkml/2013/10/13/117.

Can you please add description on why this change is being made?  This
is in preparation of common alloc interface, right?  The patch
description is kinda out-of-blue.

Thanks.

-- 
tejun
