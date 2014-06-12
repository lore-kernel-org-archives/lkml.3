Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbaFLHjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:39:33 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:39208 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717AbaFLHjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:39:32 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 12 Jun 2014 16:43:29 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, kvm@vger.kernel.org,
        linux-mm@kvack.org, Gleb Natapov <gleb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Graf <agraf@suse.de>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 09/10] mm, cma: move output param to the end of param
 list
Message-ID: <20140612074329.GC20199@js1304-P5Q-DELUXE>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1402543307-29800-10-git-send-email-iamjoonsoo.kim@lge.com>
 <20140612071930.GL12415@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612071930.GL12415@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 04:19:31PM +0900, Minchan Kim wrote:
> On Thu, Jun 12, 2014 at 12:21:46PM +0900, Joonsoo Kim wrote:
> > Conventionally, we put output param to the end of param list.
> > cma_declare_contiguous() doesn't look like that, so change it.
> 
> If you says "Conventionally", I'd like to suggest one more thing.
> Conventionally, we put 'base' ahead 'size' but dma_contiguous_reserve_area
> is opposite.

Okay. I will do it. :)

Thanks.

