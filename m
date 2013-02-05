Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3BEAVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 19:21:17 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:65065 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3BEAVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 19:21:15 -0500
Message-ID: <1360023672.12336.0.camel@kernel.cn.ibm.com>
Subject: Re: [PATCH v2] Make frontswap+cleancache and its friend be
 modularized.
From: Ric Mason <ric.masonn@gmail.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, dan.magenheimer@oracle.com,
        konrad.wilk@oracle.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, ngupta@vflare.org, rcj@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Mon, 04 Feb 2013 18:21:12 -0600
In-Reply-To: <510FD073.1060307@linux.vnet.ibm.com>
References: <1359750184-23408-1-git-send-email-konrad.wilk@oracle.com>
	 <1359881520.1328.14.camel@kernel.cn.ibm.com>
	 <510FD073.1060307@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 09:14 -0600, Seth Jennings wrote:
> On 02/03/2013 02:52 AM, Ric Mason wrote:
> > Hi Konrad,
> > On Fri, 2013-02-01 at 15:22 -0500, Konrad Rzeszutek Wilk wrote:
> > 
> > I have already enable frontswap,cleancache,zcache,
> >  FRONTSWAP [=y]  
> >  CLEANCACHE [=y]
> >  ZCACHE [=y]
> > But all of knode under /sys/kernel/debug/frontswap and cleancache still
> > zero, my swap device is enable, where I miss?
> 
> Did you pass "zcache" in the kernel boot parameters?

Thanks Seth, I think it should be add to kernel-parameters.txt.

> 
> Seth
> 


