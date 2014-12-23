Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaLWHBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:01:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49548 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaLWHBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:01:15 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-4c-54991338226c
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 1/6] f2fs: use f2fs_io_info to clean up messy
	parameters during IO path
Date: Tue, 23 Dec 2014 15:00:24 +0800
Message-id: <003101d01e7e$3cb6a620$b623f260$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG1NCgn0vPNMcmFarKO/1VZ45E3HpzSjIrQ
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t9jAV0L4ZkhBpNnWFs8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlXH/0Xamgn7WikOn
	+pkaGOexdDFyckgImEhsWNvJBmGLSVy4tx7I5uIQEljEKPFi5gNWCOcHo8TsvSfBqtgEVCSW
	d/xnAkmICPQySvw4088MkhAScJSY83Q6K4jNKeAkcbFrMTuILSyQITFt4U0mEJtFQFXi1Kkl
	QPUcHLwClhK7PlmDhHkFBCV+TL4HdhGzgJbE+p3HmSBseYnNa94yQ1ynILHj7GtGEFtEwEhi
	1d0mVogacYmNR26xTGAUnIVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ
	+bmbGMEh/kx6B+OqBotDjAIcjEo8vAvOzAgRYk0sK67MPcQowcGsJMKr3goU4k1JrKxKLcqP
	LyrNSS0+xCjNwaIkzqtk3xYiJJCeWJKanZpakFoEk2Xi4JRqYKx5LTSNZ0VuiL1Hxs0Z+6fc
	c1ygK7s8b421iWXwlqXPBDP44qW+zgh1Ytp6oSiOWz9DMXC9TX+o7ga3NSUnNh75cOrf2c2t
	J1Y/1PvynnmP504th1si3ZvuHp6nsqnaYYZh0G/VYGlvN/up3xRmHn4abq+39cJkx7u6dfEy
	jduuVcpLMFdu6FNiKc5INNRiLipOBACutuIUbQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Monday, December 22, 2014 12:35 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 1/6] f2fs: use f2fs_io_info to clean up messy parameters during IO
> path
> 
> This patch cleans up parameters on IO paths.
> The key idea is to use f2fs_io_info adding a parameter, block address, and then
> use this structure as parameters.
> 

Nice clean work.

> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

