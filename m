Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbbA0MsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:48:14 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:47207 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023AbbA0MsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:48:09 -0500
From: Bintian Wang <bintian.wang@huawei.com>
To: <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@st.com>, <broonie@linaro.org>
CC: <huxinwei@huawei.com>
Subject: [PATCH] regmap.h: correct the description of structure element in reg_field
Date: Tue, 27 Jan 2015 20:50:29 +0800
Message-ID: <1422363029-19476-1-git-send-email-bintian.wang@huawei.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.110.52.31]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect description of structure element "msb", which is
described as "reg".

Signed-off-by: Bintian Wang <bintian.wang@huawei.com>
---
 include/linux/regmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 4419b99..116655d 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -468,7 +468,7 @@ bool regmap_reg_in_ranges(unsigned int reg,
  *
  * @reg: Offset of the register within the regmap bank
  * @lsb: lsb of the register field.
- * @reg: msb of the register field.
+ * @msb: msb of the register field.
  * @id_size: port size if it has some ports
  * @id_offset: address offset for each ports
  */
-- 
1.7.9.5

