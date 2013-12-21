Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3LUSTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 13:19:32 -0500
Received: from one.firstfloor.org ([193.170.194.197]:46454 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3LUSTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 13:19:31 -0500
Date: Sat, 21 Dec 2013 19:19:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/memory-failure.c: transfer page count from head
 page to tail page after split thp
Message-ID: <20131221181929.GG20765@two.firstfloor.org>
References: <1387444174-16752-1-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387444174-16752-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Cc: stable@vger.kernel.org # 3.9+
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Looks good.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi
