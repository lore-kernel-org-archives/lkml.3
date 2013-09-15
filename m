Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3IOAQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 20:16:12 -0400
Received: from one.firstfloor.org ([193.170.194.197]:33452 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501Ab3IOAQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 20:16:10 -0400
Date: Sun, 15 Sep 2013 02:16:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2 4/4] mm/hwpoison: fix the lack of one
 reference count against poisoned page
Message-ID: <20130915001610.GT18242@two.firstfloor.org>
References: <1379202839-23939-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1379202839-23939-4-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379202839-23939-4-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
