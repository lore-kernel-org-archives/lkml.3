Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3LRVce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:32:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab3LRVNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 063/118] drm/radeon: fix typo in fetching mpll params
Date: Wed, 18 Dec 2013 13:11:40 -0800
Message-Id: <20131218211221.242751539@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 180f805f4f03b2894701f9831b4e96a308330b22 upstream.

Copy-paste typo.  Value should be 0-2, not 0-1.

Noticed-by: Sylvain BERTRAND <sylware@legeek.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2918,7 +2918,7 @@ int radeon_atom_get_memory_pll_dividers(
 			mpll_param->dll_speed = args.ucDllSpeed;
 			mpll_param->bwcntl = args.ucBWCntl;
 			mpll_param->vco_mode =
-				(args.ucPllCntlFlag & MPLL_CNTL_FLAG_VCO_MODE_MASK) ? 1 : 0;
+				(args.ucPllCntlFlag & MPLL_CNTL_FLAG_VCO_MODE_MASK);
 			mpll_param->yclk_sel =
 				(args.ucPllCntlFlag & MPLL_CNTL_FLAG_BYPASS_DQ_PLL) ? 1 : 0;
 			mpll_param->qdr =


