Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab3IIGzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 02:55:18 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60958 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3IIGzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 02:55:17 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f0a6d000007b1b-e7-522d70d3c910
Content-transfer-encoding: 8BIT
Message-id: <1378709713.29327.0.camel@AMDC1943>
Subject: Re: [RFC PATCH 0/4] mm: migrate zbud pages
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>
Date: Mon, 09 Sep 2013 08:55:13 +0200
In-reply-to: <20130906173027.GA3741@variantweb.net>
References: <1377852176-30970-1-git-send-email-k.kozlowski@samsung.com>
 <20130906173027.GA3741@variantweb.net>
References: <1377852176-30970-1-git-send-email-k.kozlowski@samsung.com>
 <20130906173027.GA3741@variantweb.net>
In-reply-to: <20130906173027.GA3741@variantweb.net>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xK7qXC3SDDBa/ZrGYs34Nm8XGGetZ
	LbpOTWWx+PTyAaPF2aY37BaXd81hs7i35j+rxdojd9ktJr97xmix7Ot7dotD+1axO3B7LN7z
	kslj06pONo9Nnyaxe5yY8ZvF48GhzSweH5/eYvHo27KK0WPz6WqPz5vkAjijuGxSUnMyy1KL
	9O0SuDLWXtzPVnCIpeLn9jb2Bsa9zF2MnBwSAiYSl998Y4GwxSQu3FvP1sXIxSEksJRRovXp
	ErAiXgFBiR+T7wEVcXAwC8hLHLmUDRJmFlCXmDRvETNE/WdGiSUnP7JC1OtLTJ3zGqxXWMBY
	4sS+aWAL2IDszcuXsIHYIkA13bNXgDUzC/xhkti3Zj87SIJFQFXi8LxmNpBlnEANjT2SIGEh
	gQKJy4dWsqCyUZRICChJ7G7vZJ/AKDQLydWzEK6eheTqBYzMqxhFU0uTC4qT0nMN9YoTc4tL
	89L1kvNzNzFC4uvLDsbFx6wOMQpwMCrx8BYw6gYJsSaWFVfmHmKU4GBWEuE9/1wnSIg3JbGy
	KrUoP76oNCe1+BAjEwenVANjh/LXI7GCmTo2p9b/37PilMHEWVNfhDKwMLOuuvlaUNHiw77l
	DW3TVu8W25Nu31Tof+7aOUtdkXgx1nR9y+9XS+TquQ7vYF8nsOpg5HYuxvXmPou7F+924Z99
	vEF/i4xfoNoC1wO9+hMnpj5p1bp4Imn724O6Rex/Hiio7eaTzTrR94hT9rSpEktxRqKhFnNR
	cSIAJ5PZvI0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2013-09-06 at 12:30 -0500, Seth Jennings wrote:
> On Fri, Aug 30, 2013 at 10:42:52AM +0200, Krzysztof Kozlowski wrote:
> > Hi,
> > 
> > Currently zbud pages are not movable and they cannot be allocated from CMA
> > region. These patches add migration of zbud pages.
> 
> Hey Krzysztof,
> 
> Thanks for the patches.  I haven't had time to look at them yet but wanted to
> let you know that I plan to early next week.
> 
> Seth

Great, thanks! Patches rebase and builds cleanly on current
mainline (v3.11-7890-ge5c832d).


Best regards,
Krzysztof


