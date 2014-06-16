Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaFPBTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 21:19:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8613 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFPBTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 21:19:06 -0400
X-AuditID: cbfee68f-b7fef6d000003970-5e-539e4607662f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Martin Kepplinger'" <martink@posteo.de>, airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1402791039-16062-1-git-send-email-martink@posteo.de>
In-reply-to: <1402791039-16062-1-git-send-email-martink@posteo.de>
Subject: Re: [PATCH] ttm: use NULL instead of 0 for ttm_bo_reserve()'s pointer
 arg.
Date: Mon, 16 Jun 2014 10:19:03 +0900
Message-id: <004d01cf8900$f5b8d490$e12a7db0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+I/Zx0HD7NfpXBRRGFzDZ+wBG9zAAAzsow
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY112t3nBBs8mKVr0njvJZHHl63s2
	i8sLL7FaXN41h83i2oqJrA6sHtu/PWD1uN99nMnj12FRj74tqxg9Pm+SC2CN4rJJSc3JLEst
	0rdL4Mo4ceM9a0EjS0XH6RPMDYxzmbsYOTkkBEwkbnT9Z4KwxSQu3FvP1sXIxSEksIxRovvB
	JTaYoic3TjFCJKYzSnza/o4ZwvnNKPFj40EWkCo2ATWJL18Os4PYIgK2Es8mbwKLMwukSyyf
	PR0sLiTgKHGtZTnYOk4BJ4lv/0+wgtjCAqESc39NB7NZBFQl3iyYxghi8wLN2XLwEhOELSjx
	Y/I9qJlaEpu3NbFC2PISm9e8BTqIA+hSdYlHf3UhTjCS+Px7EVS5iMS+F+/AHpAQuMYuMevZ
	AzaIXQIS3yYfYoHolZXYdAAaKpISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQn
	pRcZ6xUn5haX5qXrJefnbmKERGr/Dsa7B6wPMSYDrZ/ILCWanA+M9LySeENjMyMLUxNTYyNz
	SzPShJXEee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwGgzKfBwn47iNbZ3GW6/Elrf
	HQ34rBwSfTPvm8k/P3f5BwWis6Z2vMycPfPHKSGRhbE1s5LsTzd/DW75ekA9XmnTrBXlrdNr
	0qfVTPtxk5FNhuPLseImU3On7R3+H/d7xfoxcvza43ot7emzxi9/t3evW/ZBwCtHrHXR3odb
	THMKuA8efeFylU+JpTgj0VCLuag4EQBkM5tY6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV12t3nBBtt2y1r0njvJZHHl63s2
	i8sLL7FaXN41h83i2oqJrA6sHtu/PWD1uN99nMnj12FRj74tqxg9Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOHHjPWtBI0tFx+kTzA2Mc5m7GDk5JARMJJ7c
	OMUIYYtJXLi3nq2LkYtDSGA6o8Sn7e+YIZzfjBI/Nh5kAaliE1CT+PLlMDuILSJgK/Fs8iaw
	OLNAusTy2dPB4kICjhLXWpYzgdicAk4S3/6fYAWxhQVCJeb+mg5mswioSrxZMA1sMy/QnC0H
	LzFB2IISPybfg5qpJbF5WxMrhC0vsXnNW6CDOIAuVZd49FcX4gQjic+/F0GVi0jse/GOcQKj
	0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOA8+kdjCubLA4
	xCjAwajEwzvBcV6wEGtiWXFl7iFGCQ5mJRHeGDOgEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJ
	JucDU1ReSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAuKVp5
	rMvn1LWk5fauvjM2vTW64qr+0Wht05E5khoFs6v3agXH8JyLXX6ldWNLDYdG/3n5++47z+3+
	mBbxtMhzw8qZu3eErFXje/rZKnCNmucZ8VV+/aaL+NeV37iQHsYq/THrVYDRNdkI2yXlskK7
	dkQXpv2yuHDhKHtQfdl6/UelVd9eKX1SYinOSDTUYi4qTgQAkuOENUcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 15, 2014 9:11 AM, Martin Kepplinger wrote:
> 
> Fix a sparse warning: ttm_bo_reserve()'s last argument is a
> pointer to a struct, so use NULL as nullpointer.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> this applies to next-20140613. Please ignore if annoyingly irrelevant.
> 
>  drivers/gpu/drm/ttm/ttm_bo.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

