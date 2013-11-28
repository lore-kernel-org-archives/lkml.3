Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3K1BET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 20:04:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:21003 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3K1BEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 20:04:11 -0500
X-AuditID: cbfee68f-b7f336d00000481b-e9-5296968aa179
Date: Thu, 28 Nov 2013 01:04:09 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: Re: Re: [PATCH] m68k : Kill CONFIG_MTD_PARTITIONS
To: Greg Ungerer <gregungerer@westnet.com.au>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>
Cc: "linux-m68k@lists.linux-m68k.org" <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20131128010114738@eunb.song
Msgkey: 20131128010114738@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131128010114738@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <28966598.284941385600648144.JavaMail.weblogic@epv6ml06>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zjm7XtGlBBo0vmCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG/8nfWApamCqenH/D1sD4g7GLkZNDSEBFouX/dzBbQsBEYvWs
	ZewQtpjEhXvr2boYuYBqljFKXF3/iQ2maPHraewQifmMEhfet4AlWARUJf5sXMwCYrMJaEv8
	OHCVGcQWFrCS+LR9C9gGEYEEiZ87HzODNDMLdDBK7Jz7ngXiDHmJyacvg63mFRCUODnzCVCc
	A2ibksSps0oQYWWJ/b+OQh0hITFr+gVWCJtXYkb7UxYIW05i2tc1zBC2tMT5WRsYYb5Z/P0x
	VJxf4tjtHUwQ43klntwPhhmze/MXqPECElPPHGSEKFGXWHypGCLMJ7Fm4VsWmCm7Ti1nhmm9
	v2UuE4jNLKAoMaX7ITuErSXx5cc+NlRPgdguEh3/pjNNYFSehSQ1C0n7LCTtyGoWMLKsYhRN
	LUguKE5KLzLWK07MLS7NS9dLzs/dxAhJC/07GO8esD7EmAyMkYnMUqLJ+cC0klcSb2hsZmRh
	amJqbGRuaUaasJI47/2HSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGCdtupddyMl5qTp8
	u8bukJBnS7inL2Sef69PyPGYkM6MJ/NDLmkr1llPFU+8wnP47O37CduXR8TdXBl5hVty+Q2e
	S/uPbTX5sl0ibv7zKw6PHcs2Xefk6xWwv+Ov/zpH+vRhlw2ay/b7N53z3G5TqP9pd6rIlwor
	V9/0rQZxmab5J348viWU90WJpTgj0VCLuag4EQDkQzNPIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2dN2uadOCDE7pWlzeNYfNgdHj8ya5
	AMaoDJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJlK
	CmWJOaVAoYDE4mIlfTubovzSklSFjPziElulaCMDYz0jUxM9I2MDPRODWCtDAwMjU6CqhIyM
	/5O/sRS0MFU8Of+GrYHxB2MXIyeHkICKRMv/72C2hICJxOLX09ghbDGJC/fWs3UxcgHVzGeU
	uPC+hQ0kwSKgKvFn42IWEJtNQFvix4GrzCC2sICVxKftW8AGiQgkSPzc+ZgZpJlZoINRYufc
	9ywQ2+QlJp++DLaBV0BQ4uTMJ0BxDqBtShKnzipBhJUl9v86ygZxhITErOkXWCFsXokZ7U9Z
	IGw5iWlf1zBD2NIS52dtYIQ5evH3x1Bxfoljt3cwQYznlXhyPxhmzO7NX6DGC0hMPXOQEaJE
	XWLxpWKIMJ/EmoVvWWCm7Dq1nBmm9f6WuUwgNrOAosSU7ofsELaWxJcf+9hQPQViu0h0/JvO
	NIFRbhaS1Cwk7bOQtCOrWcDIsopRNLUguaA4Kb3CRK84Mbe4NC9dLzk/dxMjOD09W7KDseGC
	9SFGAQ5GJR7eA5rTgoRYE8uKK3MPMUpwMCuJ8CoUA4V4UxIrq1KL8uOLSnNSiw8xJgPjbyKz
	lGhyPjB15pXEGxobGBsaWpobmBoaWZAmrCTOu+BWUpCQQHpiSWp2ampBahHMFiYOTqkGRjnz
	92qTHerur2cLXWP/iLPO4GpM/6bdVd4Tnjy7fbEtv05M5+hFQ/1Y2WtqaVfFNiX1dZWX3yxU
	V1Ra8O5ojU3Z/DVqx3d9m38u4XnrxqsLy1V0TOSWHV0675x1UuYdcbkdonezHdbd5ZX1d0oq
	i7435YWy+OEFv1IPneLaYftm2veOHN9dbkosxRmJhlrMRcWJAKKvf4WTAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAS14SV7024658



> Hi Eunbong,

>Acked-by: Greg Ungerer 

>Did you want me to pick this up for the m68knommu git tree?
Hello, Greg.
I'm glad if  you pick up this patch.

Thanks
EunBong

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
