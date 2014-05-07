Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866AbaEGNXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:23:53 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39804 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933397AbaEGNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:23:48 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-7d-536a33e1558b
Message-id: <536A32E1.7090003@samsung.com>
Date: Wed, 07 May 2014 17:19:29 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] arm: put_user: fix possible data corruption in put_user
References: <alpine.LFD.2.11.1405050950410.980@knanqh.ubzr>
 <1399360312-13843-1-git-send-email-a.ryabinin@samsung.com>
 <alpine.LFD.2.11.1405061610450.980@knanqh.ubzr>
In-reply-to: <alpine.LFD.2.11.1405061610450.980@knanqh.ubzr>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xq7oPjbOCDbZ8NbHY9Pgaq8XlXXPY
	LG5f5rX49Owfu8WCjY8YLV5+PMHiwOaxZt4aRo+W5h42jzvX9rB5bF5S7/F5k1wAaxSXTUpq
	TmZZapG+XQJXxrn3xxgLLjFW/P77gbGBcRVjFyMHh4SAicThMyVdjJxAppjEhXvr2UBsIYGl
	jBI9u1W6GLmA7EYmiWNTTjCCJHgFtCS2Te5gA+llEVCVuL1ZHCTMJqAn8W/WdrBeUYEIiXuN
	h1khygUlfky+xwJiiwjoSByd+ZoZZCazwCNGiT/nTzCBJIQF/CT+vf7PDrFsFaPEui+t7CAJ
	TgEbiRevV4J1MwN172+dxgZhy0tsXvOWeQKjwCwkS2YhKZuFpGwBI/MqRtHU0uSC4qT0XCO9
	4sTc4tK8dL3k/NxNjJCw/rqDcekxq0OMAhyMSjy8C2QygoVYE8uKK3MPMUpwMCuJ8L7TzwoW
	4k1JrKxKLcqPLyrNSS0+xMjEwSnVwKihLzj7pU/Uh7NPj/cVyAdVnJw/K+oKf1Sv96fJZVxR
	RflRGvZBRRaL1LjehpvHWeg/E+xeeXj7m6At6izfppTN6i+MjS68WFnTZGxpYrvv643DSd//
	nnvz+8P9V8G+ex+lLI1YmVz14qOw1E5TvTMan41Xz5YvsI1oW21k9iD0ZdEb9vwf55VYijMS
	DbWYi4oTAUoHlb1JAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/14 00:13, Nicolas Pitre wrote:
> Please push this patch into Russell's patch system.
> 
> Thanks.
> 

Done - http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8051/1

Thanks.


