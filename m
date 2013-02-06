Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab3BFLNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:13:42 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:35935 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab3BFLNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:13:39 -0500
Date: Wed, 6 Feb 2013 12:13:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH 4/7] x86, UV: UV3 Update x2apic Support
Message-ID: <20130206111333.GA8696@gmail.com>
References: <20130205222648.204965172@gulag1.americas.sgi.com>
 <20130205222648.802078160@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205222648.802078160@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> 	This patch add support for the SGI UV3 hub to the
> 	common x2apic functions.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Acked-by: Russ Anderson <rja@sgi.com>
> Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
> Cc: Alexander Gordeev <agordeev@redhat.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Steffen Persvold <sp@numascale.com>
> ---
>  arch/x86/kernel/apic/x2apic_uv_x.c |  206 ++++++++++++++++++++++++++++++-------
>  1 file changed, 171 insertions(+), 35 deletions(-)

Given the size of the patch it would be nice to give a bit more 
verbose description about the nature of the changes - what 
evolved in the new HW and how does that impact the existing 
code?

Thanks,

	Ingo
