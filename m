Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3KAXNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 19:13:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:51074 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab3KAXNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 19:13:30 -0400
Message-ID: <1383347586.4776.0.camel@pasglop>
Subject: Re: linux-next: manual merge of the dt-rh tree with the powerpc tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        linuxppc-dev@lists.ozlabs.org
Date: Sat, 02 Nov 2013 10:13:06 +1100
In-Reply-To: <52742A2A.9080008@gmail.com>
References: <20131101162002.4dd386299ec42e8d8d032be2@canb.auug.org.au>
	 <52742A2A.9080008@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 17:24 -0500, Rob Herring wrote:
> On 11/01/2013 12:20 AM, Stephen Rothwell wrote:
> > Hi Rob,
> > 
> > Today's linux-next merge of the dt-rh tree got a conflict in 
> > arch/powerpc/include/asm/prom.h between commit a3e31b458844 ("of:
> > Move definition of of_find_next_cache_node into common code") from
> > the powerpc tree and commit 0c3f061c195c ("of: implement
> > of_node_to_nid as a weak function") from the dt-rh tree.
> 
> Ben, I can pick these 2 patches up instead if you want to drop them
> and avoid the conflict.

I'd rather not rebase my tree, the conflict seems to be rather trivial
to solve.

Cheers,
Ben.


