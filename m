Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbaCUHyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 03:54:22 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42242 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaCUHyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 03:54:20 -0400
Date: Fri, 21 Mar 2014 08:54:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch] x86/UV: Set n_lshift based on GAM_GR_CONFIG MMR for UV3
Message-ID: <20140321075416.GA23556@gmail.com>
References: <20140320191354.GA30582@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320191354.GA30582@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> Set the UV n_lshift value based on the GAM_GR_CONFIG MMR for UV3, making it
> independent of the socket m_val.
> 
> Remove unneeded macros.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> ---
>  arch/x86/include/asm/uv/uv_hub.h   |   12 ---------
>  arch/x86/include/asm/uv/uv_mmrs.h  |   42 ++++++++++++++++++++++++++++++++-
>  arch/x86/kernel/apic/x2apic_uv_x.c |   15 +++++++++--
>  3 files changed, 54 insertions(+), 15 deletions(-)

Please use the customary changelog style we use in the kernel:

  " Current code does (A), this has a problem when (B).
    We can improve this doing (C), because (D)."

(Of if it's a cleanup only with no functional effects then please 
state it so in the title and changelog.)

Thanks,

        Ingo
