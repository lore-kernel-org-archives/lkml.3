Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab3DWV5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:57:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43362 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579Ab3DWV4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:56:49 -0400
X-AuditID: cbfee690-b7f3c6d000001ab5-42-51770398698c
Date: Tue, 23 Apr 2013 21:56:40 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: Re: Re: [PATCH]  I2C: Change the value of octeon i2c adapter
 timeout value
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130423215111433@eunb.song
Msgkey: 20130423215111433@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130423215111433@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <30335978.78541366754199782.JavaMail.weblogic@epml20>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Zlu4M5vJAg4k/rSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG5kNtLAVvWCr+zWpnamC8wdLFyMkhJKAi0fL/OyOILSFgInH0
	8VFmCFtM4sK99WxdjFxANcsYJbbv7mSGKfr04gMLRGI+o8SGexfBEiwCqhIb525iBbHZBLQl
	3n55AGYLC0RLHDraBLZNREBN4tDtXiYQm1mgRuLy9uuMEFfIS0w+fZkdxOYVEJQ4OfMJC8Qy
	JYl7V0DmcwDFlSU2LvCGCEtIzJp+gRXC5pWY0f4UqlxOYtrXNVB3Skucn7WBEeaZxd8fQ8X5
	JY7d3sEEMhKk98n9YJgxuzd/YYOwBSSmnjkI1aoucenCJ6g4n8SahW9ZYMbsOrWcGab3/pa5
	UF8pSkzpfsgOYWtJfPmxjw3VVyCfOEo8X2c3gVF5FpLMLCTds5B0I6tZwMiyilE0tSC5oDgp
	vchErzgxt7g0L10vOT93EyMkKUzYwXjvgPUhxmRghExklhJNzgcmlbySeENjMyMLUxNTYyNz
	SzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1ME6SrFR6/XTdguI1sleP3b9R
	+GJh9srGCBl3H4dFsj7x/Uu6jzGGKi3rviYW+zAzfeuG+K8GpXLS9+dOPa5k08Yvx2ahrFH8
	7/T5d6cNZTd8s7Of+Scg4ojX7tNxUV5ivre79x0wWZfyrG11knGm23bRyYVidaydPKoeS+K6
	VsTrSDG0OyzepsRSnJFoqMVcVJwIAF0QW30gAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2TN0ZzOWBBudnWlhc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jM2H2lgK3rBU/JvVztTAeIOli5GTQ0hARaLl/3dGEFtCwETi04sPLBC2mMSFe+vZuhi5gGrm
	M0psuHeRGSTBIqAqsXHuJlYQm01AW+LtlwdgtrBAtMSho01gzSICahKHbvcygdjMAjUSl7df
	Z4RYJi8x+fRldhCbV0BQ4uTMJ1DLlCTuXQGZzwEUV5bYuMAbIiwhMWv6BVYIm1diRvtTqHI5
	iWlf1zBD2NIS52dtYIS5efH3x1Bxfoljt3cwgYwE6X1yPxhmzO7NX9ggbAGJqWcOQrWqS1y6
	8AkqziexZuFbFpgxu04tZ4bpvb9lLtRXihJTuh+yQ9haEl9+7GND9RXIJ44Sz9fZTWCUm4Uk
	MwtJ9ywk3chqFjCyrGIUTS1ILihOSq8w0StOzC0uzUvXS87P3cQITk/PluxgbLhgfYhRgINR
	iYfXYW5ZoBBrYllxZe4hRgkOZiUR3hiG8kAh3pTEyqrUovz4otKc1OJDjMnA6JvILCWanA9M
	nXkl8YbGBsaGhpbmBqaGRhakCSuJ8z5rtQ4UEkhPLEnNTk0tSC2C2cLEwSnVwGinx2j/Myfs
	17yK55tCDqrN1FRtu/VwC9ukw/f3sn+feKN4l9rhKUHnhQ5c+HfX+Giaz0f9t3cYQyT03Dxu
	rro1VfJtQOjHvllXfs2bnzpzxTvOA7KV78OampapewjqPP3OV6Muv4RvzwTu3M1JIdfiTntZ
	m9d065iuWhO0lOm9fG1vYe/+FbFKLMUZiYZazEXFiQAbWt3AkwMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3NLvfMJ016306



Sender : Wolfram Sang<wsa@the-dreams.de>
Date : 2013-04-24 01:27 (GMT+09:00)
Title : Re: Re: Re: [PATCH] I2C: Change the value of octeon i2c adapter timeout value

> Well, OK, I don't mind. We can increase it later if needed.

> Applied to for-next, thanks! Please have a look later how I changed your
> commit messages to see the preferred style.

Yes, i will check your commit message and use for reference for the next-time.
Thanks.ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
