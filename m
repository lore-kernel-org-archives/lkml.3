Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaKLLio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:38:44 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:65139 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaKLLim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:38:42 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: David Airlie <airlied@linux.ie>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v2 v3.18-rc4 2/4] drm: prime: Document gem_prime_mmap
Date: Wed, 12 Nov 2014 11:38:13 +0000
Message-Id: <1415792295-2466-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415792295-2466-1-git-send-email-daniel.thompson@linaro.org>
References: <1415639805-17477-1-git-send-email-daniel.thompson@linaro.org>
 <1415792295-2466-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gem_prime_map is not currently described in the DRM manual, lets document
it.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/gpu/drm/drm_prime.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 8467b17c8053..5d00c8726133 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -309,7 +309,7 @@ static const struct dma_buf_ops drm_gem_prime_dmabuf_ops =  {
  * Drivers can implement @gem_prime_export and @gem_prime_import in terms of
  * simpler APIs by using the helper functions @drm_gem_prime_export and
  * @drm_gem_prime_import.  These functions implement dma-buf support in terms of
- * five lower-level driver callbacks:
+ * six lower-level driver callbacks:
  *
  * Export callbacks:
  *
@@ -321,6 +321,8 @@ static const struct dma_buf_ops drm_gem_prime_dmabuf_ops =  {
  *
  *  - @gem_prime_vunmap: vunmap a buffer exported by your driver
  *
+ *  - @gem_prime_mmap (optional): mmap a buffer exported by your driver
+ *
  * Import callback:
  *
  *  - @gem_prime_import_sg_table (import): produce a GEM object from another
-- 
1.9.3

