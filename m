Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaFPFOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 01:14:25 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47304 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaFPFOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 01:14:21 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 16 Jun 2014 14:18:31 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 01/10] DMA, CMA: clean-up log message
Message-ID: <20140616051830.GA23210@js1304-P5Q-DELUXE>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1402543307-29800-2-git-send-email-iamjoonsoo.kim@lge.com>
 <87y4x2pwnk.fsf@linux.vnet.ibm.com>
 <20140612055358.GA30128@js1304-P5Q-DELUXE>
 <xa1toaxyjym3.fsf@mina86.com>
 <xa1tegyujvxv.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xa1tegyujvxv.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 11:53:16AM +0200, Michal Nazarewicz wrote:
> On Thu, Jun 12 2014, Michal Nazarewicz <mina86@mina86.com> wrote:
> > I used “function(arg1, arg2, …)” at the *beginning* of functions when
> > the arguments passed to the function were included in the message.  In
> > all other cases I left it at just “function:” (or just no additional
> > prefix).  IMO that's a reasonable strategy.
> 
> At closer inspection, I realised drivers/base/dma-contiguous.c is
> Marek's code, but the above I think is still reasonable thing to do, so
> I'd rather standardise on having “function(…)” only at the beginning of
> a function.  Just my 0.02 CHF.

Hello,

Now, I realize that these changes aren't needed in this patchset, so I
simplify this patch just to remove redundant 'CMA' prefix. Other things
can be done after merging if we need.

Thanks.
