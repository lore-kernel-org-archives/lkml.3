Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaHTCpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 22:45:02 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:41334 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaHTCpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 22:45:00 -0400
X-Original-SENDERIP: 10.177.222.131
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 20 Aug 2014 11:44:58 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] PC, KVM, CMA: Fix regression caused by wrong
 get_order() use
Message-ID: <20140820024458.GA2415@js1304-P5Q-DELUXE>
References: <1407992587-9164-1-git-send-email-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407992587-9164-1-git-send-email-aik@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 03:03:07PM +1000, Alexey Kardashevskiy wrote:
> fc95ca7284bc54953165cba76c3228bd2cdb9591 claims that there is no
> functional change but this is not true as it calls get_order() (which
> takes bytes) where it should have called ilog2() and the kernel stops
> on VM_BUG_ON().
> 
> This replaces get_order() with order_base_2() (round-up version of ilog2).
> 
> Suggested-by: Paul Mackerras <paulus@samba.org>
> Cc: Alexander Graf <agraf@suse.de>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Sorry for my fault. :(

Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Thanks.
