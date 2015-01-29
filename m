Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbbA2L4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:56:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22638 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbA2L4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:56:34 -0500
X-AuditID: cbfee61a-f79c06d000004e71-5f-54ca1feb6ca3
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1422401503-4769-1-git-send-email-jaegeuk@kernel.org>
 <1422401503-4769-3-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1422401503-4769-3-git-send-email-jaegeuk@kernel.org>
Subject: RE: [PATCH 3/5] f2fs: avoid write_checkpoint if f2fs is mounted
 readonly
Date: Thu, 29 Jan 2015 19:55:42 +0800
Message-id: <002c01d03bba$9cf2ad50$d6d807f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKDs63B3JtDSVeEmIqjDxgyUQN23AHpR/P1m2DDR7A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jQd3X8qdCDA5f1bF4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK2P95EOsBUdZKi5N
	ympgfM/cxcjJISFgItFxfxsbhC0mceHeeiCbi0NIYDqjxM8zU9ghnB+MEp0z54NVsQmoSCzv
	+M8EkhAR6GWU+HGmH2yUkEClxMI/h1hBbE4BJ4kN99+BNQgLBEtc7+wGsjk4WARUJV51VYOE
	eQUsJe4f7WKCsAUlfky+xwJiMwtoSazfeZwJwpaX2LzmLdSlChI7zr5mBLFFBKwknmxewwxR
	Iy6x8cgtlgmMgrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4
	wJ9J7WBc2WBxiFGAg1GJh5ej/mSIEGtiWXFl7iFGCQ5mJRFeMYFTIUK8KYmVValF+fFFpTmp
	xYcYpTlYlMR5lezbQoQE0hNLUrNTUwtSi2CyTBycUg2MeQUhwUGa05+mFjC4ZM55uiyhMyvi
	nau+XePU4pUP9zRdSmk3iZvxI/2Drf6HF1c6ZIVsHwuHSjk45PH6vWhYVi0wl4/nm3Xbee+o
	cMVznP7Xtp76x9TmYMF6d69C+jIxkf5JMlavghSPFIvdl/pvpL1Su3LGxWN56yqsBD7W//Qs
	vKjp+kOJpTgj0VCLuag4EQB0XFvIbAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-fsdevel-owner@vger.kernel.org [mailto:linux-fsdevel-owner@vger.kernel.org] On
> Behalf Of Jaegeuk Kim
> Sent: Wednesday, January 28, 2015 7:32 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [PATCH 3/5] f2fs: avoid write_checkpoint if f2fs is mounted readonly
> 
> Do not change any partition when f2fs is changed to readonly mode.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

