Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaFXGqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:46:53 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49420 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaFXGqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:46:52 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 24 Jun 2014 15:51:27 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, kvm@vger.kernel.org, agraf@suse.de,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] powerpc/kvm: Fix build break with
 CONFIG_KVM_BOOK3S_64_HV=y
Message-ID: <20140624065127.GA4836@js1304-P5Q-DELUXE>
References: <1403591807-9550-1-git-send-email-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403591807-9550-1-git-send-email-mpe@ellerman.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 04:36:47PM +1000, Michael Ellerman wrote:
> Commit e58e263 "PPC, KVM, CMA: use general CMA reserved area management
> framework" in next-20140624 removed arch/powerpc/kvm/book3s_hv_cma.c but
> neglected to update the Makefile, thus breaking the build.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
> 
> Hi Andrew,
> 
> This is in your akpm-current and is breaking some of the builds for
> powerpc in linux-next. Squashing this fix into the original patch would
> be best for us.
> 

I sent really same patch 10 minutes ago. :)

Thanks.
