Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500Ab3BMAcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:32:21 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:36388 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab3BMAcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:32:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130212161912.6a9e9293.akpm@linux-foundation.org>
References: <51074786.5030007@huawei.com>
	<1359995565.7515.178.camel@mfleming-mobl1.ger.corp.intel.com>
	<51131248.3080203@huawei.com>
	<5113450C.1080109@huawei.com>
	<CA+8MBb+3_xWv1wMWv0+gwWm9exPCNTZWG3mXQnBsUbc5fJnuiA@mail.gmail.com>
	<20130212161912.6a9e9293.akpm@linux-foundation.org>
Date: Tue, 12 Feb 2013 16:32:16 -0800
Message-ID: <CA+8MBbK7ZSkk2tOfjbeKuyCJ1mBT5OeY3GHKLS2EVFwH_nXZYA@mail.gmail.com>
Subject: Re: [PATCH V3] ia64/mm: fix a bad_page bug when crash kernel booting
From: Tony Luck <tony.luck@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Xishi Qiu <qiuxishi@huawei.com>, Matt Fleming <matt.fleming@intel.com>,
        fenghua.yu@intel.com, Liujiang <jiang.liu@huawei.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-mm@kvack.org,
        Hanjun Guo <guohanjun@huawei.com>, WuJianguo <wujianguo@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 4:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> But, umm, why am I sitting here trying to maintain an ia64 bugfix and
> handling bug reports from the ia64 maintainer?  Wanna swap?

That sounds like a plan.  I'll look out for a new version with the
missing #include
and less silly global variable names and try to take it before you
pull it into -mm

-Tony
