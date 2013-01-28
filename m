Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab3A1S2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:28:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54670 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3A1S2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:28:10 -0500
Date: Mon, 28 Jan 2013 19:28:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Xishi Qiu <qiuxishi@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        gong.chen@linux.intel.com
Subject: Re: [PATCH v3] mm: clean up soft_offline_page() (Re: [PATCH v2] mm: clean up soft_offline_page())
Message-ID: <20130128182809.GU30577@one.firstfloor.org>
References: <20130127014811.GL30577@one.firstfloor.org> <1359397090-9644-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359397090-9644-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> As Xishi pointed out, the patch was broken. Mce-test did catch it, but the
> related testcase HWPOISON-SOFT showed PASS falsely, so I overlooked it.

Oops. Please send a patch to Gong to fix that in mce-test

> Now I confirm that tsoft.c and tsoftinj.c in mce-test surely passes (returns
> with success exitcode) with the fixed one (attached).

-Andi
