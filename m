Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaFRUvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:51:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbaFRUvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:51:46 -0400
Date: Wed, 18 Jun 2014 13:51:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
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
Message-Id: <20140618135144.297c785260f9e2aebead867c@linux-foundation.org>
In-Reply-To: <20140617012507.GA6825@js1304-P5Q-DELUXE>
References: <1402897251-23639-1-git-send-email-iamjoonsoo.kim@lge.com>
	<539EB4C7.3080106@samsung.com>
	<20140617012507.GA6825@js1304-P5Q-DELUXE>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014 10:25:07 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> > >v2:
> > >   - Although this patchset looks very different with v1, the end result,
> > >   that is, mm/cma.c is same with v1's one. So I carry Ack to patch 6-7.
> > >
> > >This patchset is based on linux-next 20140610.
> > 
> > Thanks for taking care of this. I will test it with my setup and if
> > everything goes well, I will take it to my -next tree. If any branch
> > is required for anyone to continue his works on top of those patches,
> > let me know, I will also prepare it.
> 
> Hello,
> 
> I'm glad to hear that. :)
> But, there is one concern. As you already know, I am preparing further
> patches (Aggressively allocate the pages on CMA reserved memory). It
> may be highly related to MM branch and also slightly depends on this CMA
> changes. In this case, what is the best strategy to merge this
> patchset? IMHO, Anrew's tree is more appropriate branch. If there is
> no issue in this case, I am willing to develope further patches based
> on your tree.

That's probably easier.  Marek, I'll merge these into -mm (and hence
-next and git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git)
and shall hold them pending you review/ack/test/etc, OK?
