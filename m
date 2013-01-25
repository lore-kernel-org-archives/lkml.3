Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3AYXd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:33:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31719 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab3AYXd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:33:26 -0500
MIME-Version: 1.0
Message-ID: <1e053fad-6536-4f8f-9944-1703916c62dd@default>
Date: Fri, 25 Jan 2013 15:33:14 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: RE: [PATCH 0/4] staging: zsmalloc: various cleanups/improvments
References: <<1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com>>
In-Reply-To: <<1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: [PATCH 0/4] staging: zsmalloc: various cleanups/improvments
> 
> These patches are the first 4 patches of the zswap patchset I
> sent out previously.  Some recent commits to zsmalloc and
> zcache in staging-next forced a rebase. While I was at it, Nitin
> (zsmalloc maintainer) requested I break these 4 patches out from
> the zswap patchset, since they stand on their own.
> 
> All are already Acked-by Nitin.
> 
> Based on staging-next as of today.
> 
> Seth Jennings (4):
>   staging: zsmalloc: add gfp flags to zs_create_pool
>   staging: zsmalloc: remove unused pool name
>   staging: zsmalloc: add page alloc/free callbacks
>   staging: zsmalloc: make CLASS_DELTA relative to PAGE_SIZE
> 
>  drivers/staging/zram/zram_drv.c          |    4 +-
>  drivers/staging/zsmalloc/zsmalloc-main.c |   60 ++++++++++++++++++------------
>  drivers/staging/zsmalloc/zsmalloc.h      |   10 ++++-
>  3 files changed, 47 insertions(+), 27 deletions(-)

FWIW, please add my ack to all the patches.  I'm happy
to see zsmalloc move forward.   I'm a bit skeptical
that it will ever be capable of doing everything we
would like it to do, but am eager to see if it can.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
