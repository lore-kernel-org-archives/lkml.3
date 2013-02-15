Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161139Ab3BODyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 22:54:33 -0500
Received: from ozlabs.org ([203.10.76.45]:39435 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935122Ab3BODy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 22:54:28 -0500
Date: Fri, 15 Feb 2013 14:37:40 +1100
From: Paul Mackerras <paulus@samba.org>
To: aik@ozlabs.ru
Cc: Alexander Graf <agraf@suse.de>, Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 3/4] powerpc: preparing to support real mode optimization
Message-ID: <20130215033740.GC25015@drongo>
References: <1360584763-21988-1-git-send-email-a>
 <5118e069.22ca320a.1f08.ffffe2f0@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5118e069.22ca320a.1f08.ffffe2f0@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 11:12:42PM +1100, aik@ozlabs.ru wrote:
> From: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> he current VFIO-on-POWER implementation supports only user mode
> driven mapping, i.e. QEMU is sending requests to map/unmap pages.
> However this approach is really slow in really fast hardware so
> it is better to be moved to the real mode.
> 
> The patch adds an API to increment/decrement page counter as
> get_user_pages API used for user mode mapping does not work
> in the real mode.
> 
> CONFIG_SPARSEMEM_VMEMMAP and CONFIG_FLATMEN are supported.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> ---

The names are slightly odd, in that they include "vmemmap_" but exist
and work in the flatmem case as well.  Apart from that...

Reviewed-by: Paul Mackerras <paulus@samba.org>

Paul.
