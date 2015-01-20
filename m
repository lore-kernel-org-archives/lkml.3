Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbbATIck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:32:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27894 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbbATIcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:32:39 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-58-54be12a37c4f
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Changman Lee'" <cm224.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <000501d02e36$ba5070d0$2ef15270$@samsung.com>
In-reply-to: <000501d02e36$ba5070d0$2ef15270$@samsung.com>
Subject: RE: [f2fs-dev] [RFC PATCH 01/10] f2fs: move ext_lock out of struct
 extent_info
Date: Tue, 20 Jan 2015 16:30:50 +0800
Message-id: <008501d0348b$a52b4800$ef81d800$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGDLDqVLfBVXeuSTwGWA4IjEPa34p1ivLmA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jAd3FQvtCDBbfU7O4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxo1ZX9kK
	5rFU3D4xnbGBcQ9zFyMnh4SAicSaF/ehbDGJC/fWs3UxcnEICSxilGg7v4wJwvnBKLF06XZG
	kCo2ARWJ5R3/mUBsEQE/ien3vwJ1cHAwC3hI7DpWChIWErCUOP3vPRuIzSlgJXFt7mJWEFtY
	IFLi2o7F7CA2i4CqxPkva5lAWnmB6s/0RYCEeQUEJX5MvscCYjMLaEms33mcCcKWl9i85i3U
	nQoSO86+ZoS4wEhi1fvPzBA14hIbj9ximcAoNAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPS
	c430ihNzi0vz0vWS83M3MYIj4Jn0DsZVDRaHGAU4GJV4eB3W7g0RYk0sK67MPcQowcGsJMLr
	z7EvRIg3JbGyKrUoP76oNCe1+BCjNAeLkjivkn1biJBAemJJanZqakFqEUyWiYNTqoHRPpjv
	xcJjVmv+/1goMYl764Fty3fHH/Se7lsq27tqlarFou3hPRsrO/l3JCimfz/0MCD39vWzzJ1y
	gk5rv2xLuXOss2BOwyyb34Ku9ZwKgtHxttN9lHfsuGhTqbSjSr76oqL3cs2Dv3/5vL8q5r6r
	ubi00ci2ZlNf5XU/3hNnlQp/c78r/c2qxFKckWioxVxUnAgAMdR+C3wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping, any comments on this RFC patch set?

Thanks,

> -----Original Message-----
> From: Chao Yu [mailto:chao2.yu@samsung.com]
> Sent: Monday, January 12, 2015 3:09 PM
> To: Jaegeuk Kim; Changman Lee
> Cc: linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [RFC PATCH 01/10] f2fs: move ext_lock out of struct extent_info
> 
> Move ext_lock out of struct extent_info, then in the following patches we can
> use variables with struct extent_info type as a parameter to pass pure data.
> 

