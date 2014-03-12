Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaCLEQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:16:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29800 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaCLEQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:16:50 -0400
X-AuditID: cbfee68f-b7f156d00000276c-57-531fdfa9ba09
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 1/4] clk: samsung: add new Kconfig for Samsung common clock
 options
Date: Wed, 12 Mar 2014 13:32:58 +0900
Message-id: <1394598781-3848-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zY92V9+WDDX6/VbHY9Pgaq8XlXXPY
	LGac38dksWjrF3YHFo/NS+o9+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PfnQeMBV1sFZ1X
	GpkbGDtZuxg5OSQETCS+LFvEAmGLSVy4t56ti5GLQ0hgGaPEv5lNTDBFW9a1QSWmM0ps23+J
	BcJpY5K4274OrJ1NQFfiyfu5zCC2iEC2xKVZt8DizALaEpP3trCD2MICERItZ9sYQWwWAVWJ
	Hw17wOp5Bdwl7nYdB6rhANqmIDFnkg1ImFPAQ2Lnz1Ng5UJAJbsO7WQH2Ssh8JlNounAMag5
	AhLfJh9igeiVldh0gBniaEmJgytusExgFF7AyLCKUTS1ILmgOCm9yFivODG3uDQvXS85P3cT
	IyRk+3cw3j1gfYgxGWjcRGYp0eR8YMjnlcQbGpsZWZiamBobmVuakSasJM57/2FSkJBAemJJ
	anZqakFqUXxRaU5q8SFGJg5OqQbGFcksBycc2hJsF/DAIFhQd9eWF8t6rvdk8GU1pJnyXjLW
	LjH4/C3y0Jmt3FeLH2Ql+WeYx7Z9j9f9oLDX6/XqGQsW+pVN5g9pTpv1XydDas7/3GuS26sY
	pnXuim9lW3Q1oJ0t7rFzd+n1PZfcb5kv/addu7xEvGqf/bKJCjJcLxkLuW/UreJXYinOSDTU
	Yi4qTgQAyoUMSG8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd2V9+WDDR61K1psenyN1eLyrjls
	FjPO72OyWLT1C7sDi8fmJfUefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jx784DxoIutorOK43MDYydrF2MnBwSAiYSW9a1sUHYYhIX7q0Hsrk4hASm
	M0ps23+JBcJpY5K4276OBaSKTUBX4sn7ucwgtohAtsSlWbfA4swC2hKT97awg9jCAhESLWfb
	GEFsFgFViR8Ne8DqeQXcJe52HQeq4QDapiAxZ5INSJhTwENi589TYOVCQCW7Du1kn8DIu4CR
	YRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcEQ8k9rBuLLB4hCjAAejEg/vAk35YCHWxLLi
	ytxDjBIczEoivB9BQrwpiZVVqUX58UWlOanFhxiTgY6ayCwlmpwPjNa8knhDYxMzI0sjMwsj
	E3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamDcJeDroDbd1qpPvcSvQKlo0S1T7zN7
	agyqXzicFt1ofFFj0aIZ9aX72pljz5UdK93luK4ywHWRzoZzzaFB75ylTjLKS6X9Nbte0rPA
	R7Losa/OFtHgmbeqU299v3/zk93r6jf/lJUmPT/iYbLwSBZr6vtJT2/2Xt11Pz8+efm+xPqT
	30XO8/kpsRRnJBpqMRcVJwIAeuszJswCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new Kconfig file for adding new config option
as COMMON_CLK_SAMSUNG for Samsung common clock. This patch also
moves S3C24XX specific clock options here in this file.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/samsung/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)
 create mode 100644 drivers/clk/samsung/Kconfig

diff --git a/drivers/clk/samsung/Kconfig b/drivers/clk/samsung/Kconfig
new file mode 100644
index 0000000..26eb446
--- /dev/null
+++ b/drivers/clk/samsung/Kconfig
@@ -0,0 +1,11 @@
+config COMMON_CLK_SAMSUNG
+	bool
+	select COMMON_CLK
+
+config S3C2412_COMMON_CLK
+	bool
+	select COMMON_CLK_SAMSUNG
+
+config S3C2443_COMMON_CLK
+	bool
+	select COMMON_CLK_SAMSUNG
-- 
1.7.9.5

