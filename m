Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab3E1XEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:04:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51852 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab3E1XEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:04:21 -0400
X-AuditID: cbfee68f-b7f436d000000f81-df-51a537f4afd1
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Paul Sokolovsky'" <paul.sokolovsky@linaro.org>,
        "'Dave Airlie'" <airlied@redhat.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable]  drm.h: Fix DRM compilation with bare-metal
 toolchain.'Mark Brown'
Date: Wed, 29 May 2013 08:04:19 +0900
Message-id: <000301ce5bf7$af821270$0e863750$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAGq8R4ABU82dgA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zA90v5ksDDb7c5La4emsBk8WSZm6L
	y7vmsFmcv3+a3WLBxkeMDqwed67tYfN4v+8qm0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	vOlsYyt4zFEx4ehu1gbGNexdjBwcEgImEgtm83UxcgKZYhIX7q1n62Lk4hASWMYo0fV9PSNE
	wkRi6avf7BCJRYwSDd83MUI4fxkl3my6CVbFJqArcWz9FlYQW0TAW+LUlF/MIDazQIHEt70H
	2UC2CQlwS6xuDgIJcwrwSKz70wlWIiyQINExazETiM0ioCrR/LgTbAyvgJ3EnKWnmCBsQYkf
	k++xQIzUkli/8zgThC0vsXnNW2aIZ9QlHv3VBTlNRKCBUeL5569QNSIS+168g3rmGrvEoVUB
	ELsEJL5NPsQC0SsrsekAM0SJpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMMCRpZVjKKpBckFxUnp
	RcZ6xYm5xaV56XrJ+bmbGCGx2b+D8e4B60OMyUDrJzJLiSbnA2M7ryTe0NjMyMLUxNTYyNzS
	jDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M6zecE3kS++Z05fUot9tffjh6
	V//Jvv3RZP7/+tU/OFhfRlRF11gLvIh7+mLZWe3KKN3qzjd610+ta1y92urSvH/+vXLPMkSY
	RGO4Lq/LEwuRnhc1cVb0K7H9CxjXS1u9kWLTL37g3bmpcnt86oMpl27dM3m7siPfcvoMt3Uy
	95STFE+fCvrzVomlOCPRUIu5qDgRAODf1bbjAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jAd0v5ksDDZ4cZ7e4emsBk8WSZm6L
	y7vmsFmcv3+a3WLBxkeMDqwed67tYfN4v+8qm0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZrzpbGMreMxRMeHobtYGxjXsXYycHBICJhJLX/2GssUk
	Ltxbz9bFyMUhJLCIUaLh+yZGCOcvo8SbTTcZQarYBHQljq3fwgpiiwh4S5ya8osZxGYWKJD4
	tvcgUDcHUAO3xOrmIJAwpwCPxLo/nWAlwgIJEh2zFjOB2CwCqhLNjzvBxvAK2EnMWXqKCcIW
	lPgx+R4LxEgtifU7jzNB2PISm9e8ZQYZLyGgLvHory7IaSICDYwSzz9/haoRkdj34h3jBEah
	WUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERz9z6R3MK5qsDjE
	KMDBqMTDG/B1SaAQa2JZcWXuIUYJDmYlEd5UwaWBQrwpiZVVqUX58UWlOanFhxiTgT6dyCwl
	mpwPTEx5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cA46/Rn
	CdlavsvXmM8Jri4POffeuYNPz5m/gGNbprLcuv4ih4tZTcvf8H5fkJy++EZ29OPIg184SmsX
	r2kPXrHCqOhpkfKqj122r6zsWhSyJ588JHyiX9Boh9nKUtUfM/fkM/t/lJ0Z0eyXI6NTLr/O
	/oSlbWci34mUO3ftFEwUX2bLMv43uaTEUpyRaKjFXFScCAAjnh6QQgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Paul Sokolovsky <paul.sokolovsky@linaro.org>"

commit b6330548383cf18d608faf1c2dc0c81c60476233 upstream

An ifdef in drm.h expects to be compiled with full-fledged Linux
toolchain, but it's common to compile kernel with just bare-metal
toolchain which doesn't define __linux__. So, also add __KERNEL__
check.

[nm@ti.com: port forward to 3.9-rc6 and post to dri devel for feedback as
RFC]
Signed-off-by: Paul Sokolovsky <paul.sokolovsky@linaro.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 include/uapi/drm/drm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/drm/drm.h b/include/uapi/drm/drm.h
index 8d1e2bb..73a99e4 100644
--- a/include/uapi/drm/drm.h
+++ b/include/uapi/drm/drm.h
@@ -36,7 +36,7 @@
 #ifndef _DRM_H_
 #define _DRM_H_
 
-#if defined(__linux__)
+#if defined(__KERNEL__) || defined(__linux__)
 
 #include <linux/types.h>
 #include <asm/ioctl.h>
-- 
1.7.9.5

