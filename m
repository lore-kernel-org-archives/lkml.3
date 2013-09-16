Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab3IPWKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:10:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab3IPWKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:10:32 -0400
Date: Mon, 16 Sep 2013 18:09:57 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <1379369397-ld8lbcn-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CFD2D6@ORSMSX106.amr.corp.intel.com>
References: <1379202839-23939-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130915001352.GQ18242@two.firstfloor.org>
 <3908561D78D1C84285E8C5FCA982C28F31CFD2D6@ORSMSX106.amr.corp.intel.com>
Subject: Re: [RESEND PATCH v2 1/4] mm/hwpoison: fix traverse hugetlbfs page to
 avoid printk flood
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <3908561D78D1C84285E8C5FCA982C28F31CFD2D6@ORSMSX106.amr.corp.intel.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 09:50:06PM +0000, Luck, Tony wrote:
> This is good - but the real solution is to stop poisoning entire huge pages ... they should
> be broken into 4K pages and just one 4K page should be poisoned.
> 
> Naoya Horiguchi: I thought that you were looking at this problem some months ago. Any progress?

Sorry, I have no meaningful progress on this. Splitting hugepages is not
a trivial operation, and introduce more complexity on hugetlbfs code.
I don't hit on any usecase of it rather than memory failure, so I'm not
sure that it's worth doing now.

Thanks,
Naoya Horiguchi
