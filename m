Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3HVTj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:39:59 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35990 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3HVTj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:39:58 -0400
Date: Thu, 22 Aug 2013 12:39:49 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: dwmw2@infradead.org, Andy Shevchenko <andy.shevchenko@gmail.com>,
        Li Zefan <lizefan@huawei.com>, artem.bityutskiy@linux.intel.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>, linux-mtd@lists.infradead.org,
        hauke@hauke-m.de
Subject: Re: [PATCH RESEND 1/2] mtd: bcm47: convert kzalloc to avoid
 invalid access
Message-ID: <20130822193949.GA14837@ld-irv-0074.broadcom.com>
References: <51A6B7D4.7040202@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A6B7D4.7040202@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 10:22:12AM +0800, Libo Chen wrote:
> 
> mtd is just member of bcm47xxsflash, so we should free bcm47xxsflash not its member.
> So I use devm_kazlloc instead of kazlloc to avoid it.
> 
> * Changelog:
>    convert to devm_kzalloc
> 
> Signed-off-by: Libo chen <libo.chen@huawei.com>
> Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Resolved a conflict and pushed to l2-mtd.git. Thanks!

Brian
