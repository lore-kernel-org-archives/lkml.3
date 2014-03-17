Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbaCQC6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 22:58:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18221 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbaCQC6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 22:58:07 -0400
X-AuditID: cbfee68e-b7f566d000002344-24-532664bc16dc
Message-id: <532664BD.5020308@samsung.com>
Date: Mon, 17 Mar 2014 11:58:05 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 6/8] devfreq: exynos4: Fix power-leakage of clock on
 suspend state
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <1394698649-20996-7-git-send-email-cw00.choi@samsung.com>
 <532341C7.8070407@samsung.com>
In-reply-to: <532341C7.8070407@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkWHdPilqwwbeFyhYdPb9ZLOYfOcdq
	ce7VSkaLs01v2C0Wti1hsbi8aw6bxefeI4wWM87vY7JYev0ik8XtxhVsFm9+nGWymDB9LYvF
	4xVv2S1eHWxjsVg/4zWLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4MqYucKs4CBzxelDE9kbGO8ydTFyckgImEjMuXWXBcIWk7hw
	bz1bFyMXh5DAUkaJ3Zv+MnYxcoAV3ZzDAxGfzijRcOYSVNErRoltTy4xg3TzCmhJ/OhbygLS
	wCKgKvHtphtImA0ovP/FDTYQW1QgTGLl9CssEOWCEj8m3wOzRQRUJC6fms4IYjMLfGWSuDkP
	7DhhgSiJ99f+sULsWsQocXLiBjaQ+ZwC2hIrf+lD1OtI7G+dxgZhy0tsXvOWGaReQmAuh8SM
	U+/BhrIICEh8m3yIBeIZWYlNB5ghHpaUOLjiBssERrFZSE6ahWTsLCRjFzAyr2IUTS1ILihO
	Si8y0itOzC0uzUvXS87P3cQIjO/T/5717WC8ecD6EGMy0MqJzFKiyfnA9JBXEm9obGZkYWpi
	amxkbmlGmrCSOO+ih0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhjf18p5nnz6u2UwGsf
	n3J5+V8KcWc9ffyG3OfOuoMPE/x9rvn2zXfefWr39i/uwS6W865/27jEj2d599RPFRfsL8sI
	7z2s9yfsWVTY+4z/L3qCvMQ7pu7juflOpNNkyntH2VCVbbN4rlYt0NgvJX/nyBWb2wtyb224
	NXl6/tSpYZ+7gqadFonbqsRSnJFoqMVcVJwIAO6JBOgFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t9jQd09KWrBBjPuS1l09PxmsZh/5Byr
	xblXKxktzja9YbdY2LaExeLyrjlsFp97jzBazDi/j8li6fWLTBa3G1ewWbz5cZbJYsL0tSwW
	j1e8Zbd4dbCNxWL9jNcsDvwea+atYfRYufwLm8fiPS+ZPH4u387u0bdlFaPH8RvbmTw+b5Lz
	2Dg3NIAjqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNct
	MwfoeiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxswVZgUHmStOH5rI
	3sB4l6mLkYNDQsBE4uYcni5GTiBTTOLCvfVsXYxcHEIC0xklGs5cgnJeMUpse3KJGaSKV0BL
	4kffUhaQZhYBVYlvN91AwmxA4f0vbrCB2KICYRIrp19hgSgXlPgx+R6YLSKgInH51HRGEJtZ
	4CuTxM15TCC2sECUxPtr/1ghdi1ilDg5cQMbyHxOAW2Jlb/0Iep1JPa3TmODsOUlNq95yzyB
	UWAWkhWzkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw8ngmtYNxZYPFIUYB
	DkYlHt4JymrBQqyJZcWVuYcYJTiYlUR49WKBQrwpiZVVqUX58UWlOanFhxiTgQEwkVlKNDkf
	mNjySuINjU3MjCyNzA0tjIzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoHRc6+Uevc+
	f9dCxamLt3I0T/gV86zTMvey7tzJb9VL13x/fOja88NXAy4GZzufSN+5ItOz4dYezYnCP5vu
	mnq8dRfafz9/35l7wq03pyqrirhE2eyKZfFiXKEbukNuspNIa/GHUzM3JgfrxP7LPtTz4O2r
	8kcBE06surtIYFP6PoMby39PSNDUVmIpzkg01GIuKk4EABjcl7FiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 03/15/2014 02:52 AM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 13.03.2014 09:17, Chanwoo Choi wrote:
>> This patch disable ppmu clocks before entering suspend state to remove
>> power-leakage and enable ppmu clocks on resume function.
> 
> I don't think there is any need for this, because all the clocks are stopped anyway in SLEEP mode.

OK, I'll discard this patch on next patchset.

Best Regards,
Chanwoo Choi



