Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3BDC6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 21:58:45 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60872 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3BDC6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 21:58:43 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-b9-510f23e1a21b
Date: Mon, 4 Feb 2013 11:58:41 +0900
From: Minchan Kim <minchan@kernel.org>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH] zsmalloc: Add Kconfig for enabling PTE method
Message-ID: <20130204025841.GE2688@blaptop>
References: <1359937421-19921-1-git-send-email-minchan@kernel.org>
 <1359943329.1590.0.camel@kernel.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359943329.1590.0.camel@kernel.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 08:02:09PM -0600, Simon Jeons wrote:
> On Mon, 2013-02-04 at 09:23 +0900, Minchan Kim wrote:
> > Zsmalloc has two methods 1) copy-based and 2) pte based to access
> > allocations that span two pages.
> > You can see history why we supported two approach from [1].
> > 
> > But it was bad choice that adding hard coding to select architecture
> > which want to use pte based method. This patch removed it and adds
> > new Kconfig to select the approach.
> > 
> > This patch is based on next-20130202.
> 
> What's the meaning of 'zs' in zsmalloc? It's short for what?

I'm not right person to answer but I guess it stands for compressed slab.

-- 
Kind regards,
Minchan Kim
