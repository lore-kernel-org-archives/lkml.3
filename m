Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaKRFXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 00:23:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40491 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaKRFXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 00:23:01 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-b2-546ad7acc032
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1416275874-74186-1-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1416275874-74186-1-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 1/2] f2fs: fix to call put_page at the error
	handling routine
Date: Tue, 18 Nov 2014 13:22:05 +0800
Message-id: <006a01d002ef$b391f1f0$1ab5d5d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHZW/gja68DRPNNXXI/+0pWUwbvuZxTJbUQ
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jAd2117NCDGb8YbN4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+Pnnk9sBedZKu4e
	/8TUwPiGuYuRg0NCwETi0xrnLkZOIFNM4sK99WxdjFwcQgKLGCUubV7IDOH8YJRYsOE9K0gV
	m4CKxPKO/0wgCRGBXkaJH2f6mUESQgJOEruWz2YHsTkFnCX+Nh5gBdkgLBAncbXXFiTMIqAq
	0Xf5PxuIzStgKbH06jYoW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMkNcpyCx4+xrRhBbRMBI
	4suTx1D14hIbj9ximcAoOAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS
	83M3MYID/Jn0DsZVDRaHGAU4GJV4eBOnZoUIsSaWFVfmHmKU4GBWEuE91w0U4k1JrKxKLcqP
	LyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwNgya/ffy0+uLNun1aa2Pcit
	eWv07MMc0xKPnUgs/Zihxfpwa9ncb+K3Pqtv32kk+dC7/fCM4EP3T2yqSdS9JhEeZbBIxbKj
	pen0gs47C/QeiXjsP5l57Y77NQe/PVUfbt/aWda/V+vl3jim7Jru8FJ3y9i3bYW3Fst/ffLm
	2GaBNLkzmanqC1yVWIozEg21mIuKEwFPX1yebAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Tuesday, November 18, 2014 9:58 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 1/2] f2fs: fix to call put_page at the error handling routine
> 
> The locked page should be released before returning the function.

Good catch! I found this also, now removed from my patch set. :)

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

