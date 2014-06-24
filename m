Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaFXHMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:12:22 -0400
Received: from ozlabs.org ([103.22.144.67]:41700 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbaFXHMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:12:20 -0400
Message-ID: <1403593937.14956.4.camel@concordia>
Subject: Re: [PATCH] powerpc/kvm: Fix build break with
 CONFIG_KVM_BOOK3S_64_HV=y
From: Michael Ellerman <mpe@ellerman.id.au>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, kvm@vger.kernel.org, agraf@suse.de,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 24 Jun 2014 17:12:17 +1000
In-Reply-To: <20140624065127.GA4836@js1304-P5Q-DELUXE>
References: <1403591807-9550-1-git-send-email-mpe@ellerman.id.au>
	 <20140624065127.GA4836@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 15:51 +0900, Joonsoo Kim wrote:
> On Tue, Jun 24, 2014 at 04:36:47PM +1000, Michael Ellerman wrote:
> > Commit e58e263 "PPC, KVM, CMA: use general CMA reserved area management
> > framework" in next-20140624 removed arch/powerpc/kvm/book3s_hv_cma.c but
> > neglected to update the Makefile, thus breaking the build.
> > 
> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > ---
> > 
> > Hi Andrew,
> > 
> > This is in your akpm-current and is breaking some of the builds for
> > powerpc in linux-next. Squashing this fix into the original patch would
> > be best for us.
> > 
> 
> I sent really same patch 10 minutes ago. :)

Haha, oh well, I should have had a coffee instead :)

cheers


