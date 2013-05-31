Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab3EaH5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:57:31 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:51629 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3EaH50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 03:57:26 -0400
MIME-Version: 1.0
In-Reply-To: <51A6B7D4.7040202@huawei.com>
References: <51A6B7D4.7040202@huawei.com>
Date: Fri, 31 May 2013 09:57:25 +0200
Message-ID: <CACna6rwz8fx_wBoNe2bko+Rtoq2xpfAGgCKZDFy4iBqGQuSbkg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/2] mtd: bcm47: convert kzalloc to avoid invalid access
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: dwmw2@infradead.org, Andy Shevchenko <andy.shevchenko@gmail.com>,
        artem.bityutskiy@linux.intel.com, Bill Pemberton <wfp5p@virginia.edu>,
        hauke@hauke-m.de, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/30 Libo Chen <clbchenlibo.chen@huawei.com>:
> mtd is just member of bcm47xxsflash, so we should free bcm47xxsflash not its member.
> So I use devm_kazlloc instead of kazlloc to avoid it.

I think you should use
mtd: bcm47xxsflash:
prefix for both patches, but Artem or David may want to comment on that.

Nice trick with that devm_kzalloc, I didn't know it.

-- 
Rafał
