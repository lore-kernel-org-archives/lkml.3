Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaLXIFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 03:05:30 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:26962 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaLXIF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:05:29 -0500
X-AuditID: cbfee61a-f79c06d000004e71-95-549a73c3ca74
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <003701d01e8b$883e0e00$98ba2a00$@samsung.com>
 <20141223185033.GA12880@jaegeuk-mac02>
In-reply-to: <20141223185033.GA12880@jaegeuk-mac02>
Subject: RE: [f2fs-dev][PATCH] f2fs: cleanup trace event of
 f2fs_submit_page_{m,}bio with DECLARE_EVENT_CLASS
Date: Wed, 24 Dec 2014 16:04:38 +0800
Message-id: <006f01d01f50$5e509b10$1af1d130$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKlyWAd2IjdzbzVpFQUHOhLZ6kD3QGn5twMmuXNwbA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAd3DxbNCDBaukbK4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxoFl7awF
	d1kqvq06wtbA+Ia5i5GTQ0LAROL/poNQtpjEhXvr2boYuTiEBBYxSnzc3MAM4fxglGj78JYN
	pIpNQEViecd/JhBbREBNonffFCCbg4NZoEhi1QoBkLCQQJLE5YYeRhCbU8BY4unaHlYQW1gg
	X6L5WgtYK4uAqsTTSUvBbF4BS4mbK9azQdiCEj8m32MBsZkFtCTW7zzOBGHLS2xe8xbqUAWJ
	HWdfM0KcYCVxoq2LHaJGXGLjkVssExiFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRnAMPJPawbiyweIQowAHoxIP746IWSFCrIllxZW5hxglOJiVRHhDs4BC
	vCmJlVWpRfnxRaU5qcWHGKU5WJTEeZXs20KEBNITS1KzU1MLUotgskwcnFINjBP6C/9KTX5x
	OyyRM0reh1u9wH1XdMj5Xb9WKd5oTE63fL2upyP43C23QP642EDGc/mxW2W/BM8OKnu09O4y
	3hb7Gw/tC0zOM5k2XNP9yjx/vf+Gnhf2t7lX3zr6ukB8W85Uy3V951oV7z5KrnX49Izhqtge
	nvCYC5cTBbPDpkr8rTZze3DKRImlOCPRUIu5qDgRANeDMVp9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, December 24, 2014 2:51 AM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][PATCH] f2fs: cleanup trace event of f2fs_submit_page_{m,}bio with
> DECLARE_EVENT_CLASS
> 
> Hi Chao,
> 
> Is there a chance to use *fio* as one parameter?

Good idea!

How about the following patch which cleanup parameters for
trace_f2fs_submit_{read_,write_,page_,page_m}bio with fio?

Thanks,

> 
> Thanks,
> 


