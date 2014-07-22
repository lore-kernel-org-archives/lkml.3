Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaGVCR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:17:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17220 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaGVCR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:17:57 -0400
X-AuditID: cbfee68f-b7fef6d000003970-56-53cdc9d1b1b0
Date: Tue, 22 Jul 2014 02:17:53 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: Re: Re: [PATCH] lib : lz4 using put_unaligned_le16 instead of
 put_unaligned
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "chanho.min@lge.com" <chanho.min@lge.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20140722021302896@eunb.song
Msgkey: 20140722021302896@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140722021302896@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <12396088.204011405995472026.JavaMail.weblogic@epml18>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zHd2LJ88GG7zbLmhxedccNgdGj8+b
	5AIYoxoYbRKLkjMyy1IVUvOS81My89JtlUJD3HQtlBQy8otLbJWijQyM9YxMTfSMTMz1LA1i
	rYxMlRTyEnNTbZUqdKF6lRSKkguAanMri4EG5KTqQcX1ilPzUhyy8ktBLtErTswtLs1L10vO
	z1VSKEvMKQUaoaSfMJUxY96khSwFTSwVv479ZW9g/MDcxcjJISSgItHy/zsjiC0hYCLx5MoR
	ZghbTOLCvfVsXYxcQDXLGCVuX77GBlO09Px8JojEHEaJrkn7wDpYBFQl5ny/xQJiswloS/w4
	cBUsLiwQIvF7RiOYLSKgJdHbfhxoGwcHs0CexISVUhBHyEtMPn2ZHcTmFRCUODnzCQvELiWJ
	J/9OMUHElSUeLf8DFZeQmDX9AiuEzSsxo/0pVFxOYtrXNVAPSEucn7WBEeaZxd8fQ8X5JY7d
	3sEEcgJI75P7wTBjdm/+AvWigMTUMwehWtUl+tb/YIew+STWLHwLtUpQ4vS1bmaY3vtb5oKd
	ySygKDGl+yE7hK0l8eXHPjZUb3EA2U4Spy7xTWBUnoUkMwtJ9ywk3chqFjCyrGIUTS1ILihO
	Si8yRo7rTYyQJNi/g/HuAetDjPsZgTEykVlKNDkfmEbzSuINjc2MLExNTI2NzC3NKBQ2MbWw
	MDGiirCSOO/9h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgdLvlzLXvdJrHnYfa9Ou0v
	S96t3FGp6fZH57pee6Cc35Pk4Jo+dTvT5JJVodv12pVL+qK7ypViezQ4ErfcO/Hg24KT2wqk
	8vmcP252+mIoPHePEu8nVrYJJ4+dMuj2yDrH5yepUfZH90Dg8jN/DaOvnK/mNrrHxjiVb26Q
	eeSFRzqFfy8xFiuxFGckGmoxFxUnAgAl7nYl9QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e92r+7Fk2eDDR6d5bO4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GfMmLWQpaGKp+HXsL3sD4wfmLkZODiEBFYmW/98ZQWwJAROJpefnM0HYYhIX7q1n62LkAqqZ
	wyjRNWkfWAOLgKrEnO+3WEBsNgFtiR8HroLFhQVCJH7PaASzRQS0JHrbjwMN5eBgFsiTmLBS
	CmKXvMTk05fZQWxeAUGJkzOfsEDsUpJ48u8UE0RcWeLR8j9QcQmJWdMvsELYvBIz2p9CxeUk
	pn1dwwxhS0ucn7WBEebmxd8fQ8X5JY7d3sEEcgJI75P7wTBjdm/+wgZhC0hMPXMQqlVdom/9
	D3YIm09izcK3UKsEJU5f62aG6b2/ZS7YmcwCihJTuh+yQ9haEl9+7GND9RYHkO0kceoS3wRG
	uVlIMrOQdM9C0o2sZgEjyypG0dSC5ILipPQKQ73ixNzi0rx0veT83E2M4PT0bOEOxi/nrQ8x
	CnAwKvHwWsifDRZiTSwrrsw9xCjBwawkwtu+ByjEm5JYWZValB9fVJqTWnyIMRkYfROZpUST
	84GpM68k3tDYwNjQ0NLcwNTQyII0YSVx3rs3k4KEBNITS1KzU1MLUotgtjBxcEo1MJbsm3dq
	oem0x92BAToF2YzVh8/vSlnmW7GiPONx/IfcK6EZt14/si1fmPDluFB6UQ7v67qDLCe3aSQc
	8Cr/fuFevbCQlvDzDz9aeSzPyf34euy8f0/r7fCnBtf3hHRMmB6z9/RUyQA+w48F2x55Htu8
	48yc97Kn+deEFFRK3xHzaP7qxqAetFCJpTgj0VCLuag4EQD0hlIokwMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6M2I33K002549


> Odd line wrapping :(

Sorry, for this. 

> Anyway, is this a new problem?  Or something that has always been there
> in this compression function?

Actually, i have tested zram with lz4 functions in my board(mips64 big endian). 
Everytime  i try to mount my ext4 zram image i have failed. 
After applying this patch, that problem was disappeared.

Thanks. ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
