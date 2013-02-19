Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485Ab3BSV46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 16:56:58 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:36520 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933545Ab3BSV45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 16:56:57 -0500
MIME-Version: 1.0
In-Reply-To: <5113450C.1080109@huawei.com>
References: <51074786.5030007@huawei.com>
	<1359995565.7515.178.camel@mfleming-mobl1.ger.corp.intel.com>
	<51131248.3080203@huawei.com>
	<5113450C.1080109@huawei.com>
Date: Tue, 19 Feb 2013 13:56:55 -0800
Message-ID: <CA+8MBbKuBheEj9t8whJBc=S7NdxCF8MvuD2Ajm7suP=7JC01fg@mail.gmail.com>
Subject: Re: [PATCH V3] ia64/mm: fix a bad_page bug when crash kernel booting
From: Tony Luck <tony.luck@gmail.com>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Matt Fleming <matt.fleming@intel.com>, fenghua.yu@intel.com,
        Liujiang <jiang.liu@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-mm@kvack.org, Hanjun Guo <guohanjun@huawei.com>,
        WuJianguo <wujianguo@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Foolishly sent an earlier reply from Outlook which appears
to have mangled/lost it. Trying again ...

> In efi_init() memory aligns in IA64_GRANULE_SIZE(16M). If set "crashkernel=1024M-:600M"

Is this where the real problem begins?  Should we insist that users
provide crashkernel
parameters rounded to GRANULE boundaries?

-Tony
