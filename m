Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaE2EfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:35:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402AbaE2EfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 3.14 062/140] drm/radeon: fix typo in spectre_golden_registers
Date: Wed, 28 May 2014 21:33:21 -0700
Message-Id: <20140529043057.454642200@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit f1553174a207f68a4ec19d436003097e0a4dc405 upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -1095,7 +1095,7 @@ static const u32 spectre_golden_register
 	0x8a14, 0xf000003f, 0x00000007,
 	0x8b24, 0xffffffff, 0x00ffffff,
 	0x28350, 0x3f3f3fff, 0x00000082,
-	0x28355, 0x0000003f, 0x00000000,
+	0x28354, 0x0000003f, 0x00000000,
 	0x3e78, 0x00000001, 0x00000002,
 	0x913c, 0xffff03df, 0x00000004,
 	0xc768, 0x00000008, 0x00000008,


