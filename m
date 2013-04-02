Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab3DBO6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:58:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab3DBO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:58:35 -0400
Message-ID: <515AF1E7.9020806@redhat.com>
Date: Tue, 02 Apr 2013 10:57:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        hughd@google.com, khlebnikov@openvz.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Zhangdianfang <zhangdianfang@huawei.com>
Subject: Re: [PATCH] mm/vmscan: fix error return in kswapd_run()
References: <515ABC79.5060900@huawei.com>
In-Reply-To: <515ABC79.5060900@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 07:09 AM, Xishi Qiu wrote:
> Fix the error return value in kswapd_run(). The bug was
> introduced by commit d5dc0ad928fb9e972001e552597fd0b794863f34
> "mm/vmscan: fix error number for failed kthread".
>
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
