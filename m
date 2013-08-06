Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3HFJZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:25:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41264 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3HFJZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:25:36 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-5b-5200c10dda25
Message-id: <1375781132.2003.4.camel@AMDC1943>
Subject: Re: [RFC PATCH 1/4] zbud: use page ref counter for zbud pages
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Bob Liu <bob.liu@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Date: Tue, 06 Aug 2013 11:25:32 +0200
In-reply-to: <5200BB18.9010105@oracle.com>
References: <1375771361-8388-1-git-send-email-k.kozlowski@samsung.com>
 <1375771361-8388-2-git-send-email-k.kozlowski@samsung.com>
 <5200BB18.9010105@oracle.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xa7p8BxmCDM5aW8xZv4bNYuOM9awW
	XaemslicbXrDbnF51xw2i3tr/rNarD1yl91i8rtnjBaH9q1it5jX/pLVgctj06dJ7B4nZvxm
	8XhwaDOLx8ent1g8+rasYvTYfLra4/MmuQD2KC6blNSczLLUIn27BK6Mrdt+sxZ0MFX83zWZ
	pYHxJGMXIyeHhICJxOt/k5ggbDGJC/fWs3UxcnEICSxllHj8dTYzhPOZUWLToylsIFW8AnoS
	y75sYAWxhQXcJF6dmc0OYrMJGEtsXr4ErEZEQEHi9afzTCDNzAJfmCQ6Fy8EW8cioCrxd9k7
	MJtTQEtizc8NLBAbFjNKvO98xAKSYBZQl5g0bxEzxE1KErvbO9kh4vISm9e8ZYa4QlDix+R7
	LBMYBWYhaZmFpGwWkrIFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIi4+sOxqXHrA4x
	CnAwKvHw7rj+P1CINbGsuDL3EKMEB7OSCK/KToYgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYw1
	WhuaFp6SmCqu8I5DhWOJiPzRjWaJ6XJvnuZsKcneMaFPQHXTym2Oyxdo6t1JELt56nOykafx
	/EMfijPmiJ+Y9WPRl4NhzRx9U4RfeaRoK/yJKYp8+/LNm9lRrbo/fh8LFYvY2FfT5cosfuDr
	T5PLV9zCFPU/B8/+e+V+QqSbxCSdV1mbevuUWIozEg21mIuKEwFbc30TagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bob,

Thank you for review.

On wto, 2013-08-06 at 17:00 +0800, Bob Liu wrote:
> Nit picker, how about change the name to adjust_lists() or something
> like this because we don't do any rebalancing.

OK, I'll change it.

Best regards,
Krzysztof


