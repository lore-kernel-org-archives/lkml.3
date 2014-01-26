Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaAZFNr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 00:13:47 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42648 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaAZFNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 00:13:45 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-a5-52e49988770e
From: Jungseung Lee <js07.lee@samsung.com>
To: "'Catalin Marinas'" <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
References: <00d501cf136a$24ec49c0$6ec4dd40$@samsung.com>
 <20140124154321.GI19052@arm.com>
In-reply-to: <20140124154321.GI19052@arm.com>
Subject: RE: [Q] L1_CACHE_BYTES on flush_pfn_alias function.
Date: Sun, 26 Jan 2014 14:13:43 +0900
Message-id: <003c01cf1a55$623979f0$26ac6dd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQEJaKXqBdSIR1Yoa1EyTGESSXvhhQHCeP7nnBPDxXA=
Content-language: ko
X-OriginalArrivalTime: 26 Jan 2014 05:13:41.0360 (UTC)
 FILETIME=[60AE1F00:01CF1A55]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWyRsSkQLdj5pMgg3VPZSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGxX3rmAu6OCt+TtjK2MA4jb2LkZNDQsBE4teZzSwQtpjEhXvr
	2boYuTiEBJYySpxesIAZpmjBp15WiMR0Ron+zhlQVfuZJPb8Pc0C17Ji2jwmkBY2AS2JG783
	sYLYIgL6Eouv3ACzmQUSJNp3vwIbKyQQI/F/6i9GEJtTQFdi2cFtYDcJC9hI3P7RCWazCKhK
	TO/aAlbDK2ApseTxLVYIW1Dix+R7QIs5gGaqS0yZkgsxXlviybsLrBBXK0jsOPuaEeIEK4kj
	R/czQtSISOx78Y4R4gRlic+nexkh6kMl9n1sBPtFQmAfu0Tv0hPMEDcISHybfAhsl4SArMSm
	A9BQkZQ4uOIGywRG6VlILpqFcNEsJBfNQrJ5ASPLKkbR1ILkguKk9CJDveLE3OLSvHS95Pzc
	TYzAGD3971nvDsbbB6wPMSYDbZ/ILCWanA+M8bySeENjMyMLUxNTYyNzSzPShJXEeZMeJgUJ
	CaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDReztbHsHSJzu4I/n37vQLcc+Uuz+CeKF798fnD
	7LzUgriTB0L42P89FE1eUrH38LoCi8B9TddkUyfMEHpl9btXRHCOY0HRri2dDb3/Fd8IyV/p
	c52Q+9U37n9fjR7jie2KPGEP2MLn/b/u4Zz6+fnCFcEbD/kk+Cxdm3n7xqZbHw/uLIhQjlZi
	Kc5INNRiLipOBABQ63t75wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQd2OmU+CDCY0i1pc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjIv71jEXdHFW/JywlbGB
	cRp7FyMnh4SAicSCT72sELaYxIV769m6GLk4hASmM0r0d86AcvYzSez5e5oFwlnKKLFi2jwm
	kBY2AS2JG783gbWLCOhLLL5yA8xmFkiQaN/9ihnEFhKIkfg/9RcjiM0poCux7OA2sNXCAjYS
	t390gtksAqoS07u2gNXwClhKLHl8ixXCFpT4Mfke0GIOoJnqElOm5EKM15Z48u4C1NUKEjvO
	vmaEOMFK4sjR/YwQNSIS+168Y4Q4QVni8+leRoj6UIl9HxtZJjCKzkKyYRbChllINsxCMmkB
	I8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAE8Ex6B+OqBotDjAIcjEo8vBMtngQJsSaW
	FVfmHmKU4GBWEuHVnwwU4k1JrKxKLcqPLyrNSS0+xJgM9P9EZinR5HxgcsoriTc0NjEzsjQy
	N7QwMjYnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsaJGR5NJjPnxrZ4vj3zVke0MCxR
	3krkQIpem8KDft/Pj3Zs+VyYedD5zJn1PyO2Vr62PNmu/d7fclpbAfdp1/0Kb849PhBltaDO
	wURs6pYqFi6NU4kprHOZb27k5czY0dqitnLZ94x0fQeGis9/2iIS8t06Dp2vk7R5G1TyZjEr
	11T/IIdFN5RYijMSDbWYi4oTARRHWthEAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not to flush some more bytes. In the scenario, they can *omit* to flush last 32 bytes.

L1_CACHE_BYTES = 64 (ARM v7, CA9)

asm(    "mcrr   p15, 0, %1, %0, c14\n"
    "   mcr p15, 0, %2, c7, c10, 4"
        :
        : "r" (to), "r" (to + PAGE_SIZE - L1_CACHE_BYTES), "r" (zero)
        : "cc");
-----Original Message-----
From: Catalin Marinas [mailto:catalin.marinas@arm.com] 
Sent: Saturday, January 25, 2014 12:43 AM
Cc: linux-arm-kernel@lists.infradead.org; linux@arm.linux.org.uk; linux-kernel@vger.kernel.org
Subject: Re: [Q] L1_CACHE_BYTES on flush_pfn_alias function.

On Fri, Jan 17, 2014 at 09:54:42AM +0000,        wrote:
> Follow the mailing-list
> http://comments.gmane.org/gmane.linux.ports.arm.omap/31686
> 
> >>Setting the L1 cache line size larger than it actually is should be safe.
> 
> the written code expected as L1_CACHE_BYTES should be real cache line 
> size has bug.
> It looks like that flush_pfn_alias function should be fixed.

Did you actually notice any problem with flushing some more bytes? It's a clean+invalidate rather than invalidate, I don't see any problem.

--
Catalin

