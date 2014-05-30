Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbaE3BZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:25:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46151 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbaE3BZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:25:52 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-6a-5387de1fa140
Message-id: <5387DE1E.3010309@samsung.com>
Date: Fri, 30 May 2014 10:25:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] extcon: arizona: Use extcon cable API
References: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1401377274-10249-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1401377274-10249-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkRFf+XnuwwbWpPBb/ptxgt7i8aw6b
	xe3GFWwWy9/+Z3Ng8Xg58TebR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGW0L97AWvCbueLi
	hFNMDYwLmbsYOTkkBEwktp5dzQZhi0lcuLceyObiEBJYyiix4/AiVpiimecXMIHYQgLTGSUO
	zTCCKHrNKPHhxSd2kASvgJZEz9dVjF2MHBwsAqoSe/+4gITZgML7X9wAWyAqECaxcvoVFohy
	QYkfk++B2SICFhJTltwCO4hZIFFizrkvYCOFBewkfh7cwQyxaz6jxL4jDYwgCU6gQdPfXGaF
	aNCR2N86jQ3ClpfYvOYtWIOEwCp2iUfrv4I1sAgISHybfIgF5DgJAVmJTQegvpeUOLjiBssE
	RrFZSG6ahWTsLCRjFzAyr2IUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIjKLT/5717mC8fcD6
	EGMy0MqJzFKiyfnAKMwriTc0NjOyMDUxNTYytzQjTVhJnDfpYVKQkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBsbYhlm8fqtYA87/if95ZPkG4e/vpvQE7z6sHST+YW/s/og7RSxOlhV3JJwE
	bCb2n5fosrayEeiKYbUylWVmf37j87nMFb5h6Q+M+Bc07jzctlfA7qbRLEH/Hh8tnSOqOQcT
	hLznTPxZEzR7W9j6fQ+F5M1yuxaL5e51e7g4+MLkxB8N39TM3yuxFGckGmoxFxUnAgD9BJAr
	uAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoK78vfZggyudrBb/ptxgt7i8aw6b
	xe3GFWwWy9/+Z3Ng8Xg58TebR9+WVYwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmtC/ewFrwm7ni4oRTTA2MC5m7GDk5JARMJGaeX8AEYYtJXLi3ng3EFhKY
	zihxaIZRFyMXkP2aUeLDi0/sIAleAS2Jnq+rGLsYOThYBFQl9v5xAQmzAYX3v7gB1isqECax
	cvoVFohyQYkfk++B2SICFhJTltwC28sskCgx59wXsJHCAnYSPw/uYIbYNZ9RYt+RBkaQBCfQ
	oOlvLrNCNOhI7G+dxgZhy0tsXvOWeQKjwCwkO2YhKZuFpGwBI/MqRtHUguSC4qT0XEO94sTc
	4tK8dL3k/NxNjOAYfSa1g3Flg8UhRgEORiUe3sbI9mAh1sSy4srcQ4wSHMxKIryOh4FCvCmJ
	lVWpRfnxRaU5qcWHGJOBITCRWUo0OR+YPvJK4g2NTcyMLI3MDS2MjM1JE1YS5z3Qah0oJJCe
	WJKanZpakFoEs4WJg1OqgfH4xNWH/85omXvow8G325MCK5ef+ZMXsShM4Pzc6qs56q7/f/LE
	BkaeUld5raboHqBW2/crWucNQ77BTMPou5fmhlxtWRzpv1J49gZ/1uWT7nDuXrS2xG5ieM0j
	Lbn+Q3uSLc67HMr8UH1W96zpbPXS4pnvbDf0Zk/i5Jiw/DI/C19FwiRv3W1KLMUZiYZazEXF
	iQDUYejRFQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 12:27 AM, Charles Keepax wrote:
> From: Nikesh Oswal <Nikesh.Oswal@wolfsonmicro.com>
> 
> Use extcon cable API instead of state API as it is much more
> idiomatic.
> 
> Signed-off-by: Nikesh Oswal <Nikesh.Oswal@wolfsonmicro.com>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |   15 ++++++---------
>  1 files changed, 6 insertions(+), 9 deletions(-)

Applied after modified patch title.

Thanks,
Chanwoo Choi 

