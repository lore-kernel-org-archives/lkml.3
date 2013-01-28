Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab3A1SdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:33:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab3A1SdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:33:17 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Xishi Qiu <qiuxishi@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        gong.chen@linux.intel.com
Subject: Re: [PATCH v3] mm: clean up soft_offline_page() (Re: [PATCH v2] mm: clean up soft_offline_page())
Date: Mon, 28 Jan 2013 13:32:56 -0500
Message-Id: <1359397976-10205-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130128182809.GU30577@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 07:28:09PM +0100, Andi Kleen wrote:
> > 
> > As Xishi pointed out, the patch was broken. Mce-test did catch it, but the
> > related testcase HWPOISON-SOFT showed PASS falsely, so I overlooked it.
> 
> Oops. Please send a patch to Gong to fix that in mce-test

OK. I'll try this soon.

Thanks,
Naoya

> > Now I confirm that tsoft.c and tsoftinj.c in mce-test surely passes (returns
> > with success exitcode) with the fixed one (attached).
