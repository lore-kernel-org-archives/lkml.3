Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3BEAjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 19:39:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18153 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3BEAjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 19:39:15 -0500
Date: Mon, 4 Feb 2013 19:38:59 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ric Mason <ric.masonn@gmail.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>, dan.magenheimer@oracle.com,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        ngupta@vflare.org, rcj@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2] Make frontswap+cleancache and its friend be
 modularized.
Message-ID: <20130205003859.GC17565@konrad-lan.dumpdata.com>
References: <1359750184-23408-1-git-send-email-konrad.wilk@oracle.com>
 <1359881520.1328.14.camel@kernel.cn.ibm.com>
 <510FD073.1060307@linux.vnet.ibm.com>
 <1360023672.12336.0.camel@kernel.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360023672.12336.0.camel@kernel.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 06:21:12PM -0600, Ric Mason wrote:
> On Mon, 2013-02-04 at 09:14 -0600, Seth Jennings wrote:
> > On 02/03/2013 02:52 AM, Ric Mason wrote:
> > > Hi Konrad,
> > > On Fri, 2013-02-01 at 15:22 -0500, Konrad Rzeszutek Wilk wrote:
> > > 
> > > I have already enable frontswap,cleancache,zcache,
> > >  FRONTSWAP [=y]  
> > >  CLEANCACHE [=y]
> > >  ZCACHE [=y]
> > > But all of knode under /sys/kernel/debug/frontswap and cleancache still
> > > zero, my swap device is enable, where I miss?
> > 
> > Did you pass "zcache" in the kernel boot parameters?
> 
> Thanks Seth, I think it should be add to kernel-parameters.txt.

Actually I think you spotted a bug. It made sense when the zcache was
built-in the kernel. But as a module - it should be enabled when the
system admin loads the module.
> 
> > 
> > Seth
> > 
> 
> 
