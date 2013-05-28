Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3E1UOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:14:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23796 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab3E1UOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:14:39 -0400
Date: Tue, 28 May 2013 16:14:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for May 28 (xen / frontswap)
Message-ID: <20130528201409.GA25433@phenom.dumpdata.com>
References: <20130528172142.4a70c0bbe4943495699e4e5e@canb.auug.org.au>
 <51A50AEC.7040705@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A50AEC.7040705@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 12:52:12PM -0700, Randy Dunlap wrote:
> On 05/28/13 00:21, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130527:
> > 
> > New tree: drm-tegra
> > 
> 
> on x86_64:
> 
> drivers/xen/tmem.c: In function 'xen_tmem_init':
> drivers/xen/tmem.c:410:7: error: 'frontswap' undeclared (first use in this function)

I have already a patch for this in my tree.
