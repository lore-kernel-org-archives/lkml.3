Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaFXHro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:47:44 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:43249 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaFXHrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:47:42 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 24 Jun 2014 16:52:23 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v3 -next 0/9] CMA: generalize CMA reserved area
 management code
Message-ID: <20140624075223.GE4836@js1304-P5Q-DELUXE>
References: <1402897251-23639-1-git-send-email-iamjoonsoo.kim@lge.com>
 <539EB4C7.3080106@samsung.com>
 <20140617012507.GA6825@js1304-P5Q-DELUXE>
 <20140618135144.297c785260f9e2aebead867c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618135144.297c785260f9e2aebead867c@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 01:51:44PM -0700, Andrew Morton wrote:
> On Tue, 17 Jun 2014 10:25:07 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > > >v2:
> > > >   - Although this patchset looks very different with v1, the end result,
> > > >   that is, mm/cma.c is same with v1's one. So I carry Ack to patch 6-7.
> > > >
> > > >This patchset is based on linux-next 20140610.
> > > 
> > > Thanks for taking care of this. I will test it with my setup and if
> > > everything goes well, I will take it to my -next tree. If any branch
> > > is required for anyone to continue his works on top of those patches,
> > > let me know, I will also prepare it.
> > 
> > Hello,
> > 
> > I'm glad to hear that. :)
> > But, there is one concern. As you already know, I am preparing further
> > patches (Aggressively allocate the pages on CMA reserved memory). It
> > may be highly related to MM branch and also slightly depends on this CMA
> > changes. In this case, what is the best strategy to merge this
> > patchset? IMHO, Anrew's tree is more appropriate branch. If there is
> > no issue in this case, I am willing to develope further patches based
> > on your tree.
> 
> That's probably easier.  Marek, I'll merge these into -mm (and hence
> -next and git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git)
> and shall hold them pending you review/ack/test/etc, OK?

Hello, Marek.

Could you share your decision about this patchset?

Thanks.
