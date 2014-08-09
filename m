Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaHIIfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 04:35:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56586 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaHIIfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 04:35:47 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-6e-53e5dd627f6a
Date: Sat, 09 Aug 2014 17:35:45 +0900
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: [alsa-devel] [PATCH 2/2] mfd: arizona: Update DT binding to support
 INn_MODE
Message-id: <20140809173545.2fc1f72e@songinha-Samsung-DeskTop-System>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsWyRsSkWDfp7tNgg7Pd/BZXLh5ispj68Amb
	xb8pN9gtrn95zmox/8g5Vov+NwtZLc69Wslocf/rUUaLb1c6mCwu75rDZrH0+kUmi+Vv/7NZ
	TJi+lsWide8RdovT3awO/B4bPjexeayZt4bR43JfL5PHzll32T1WLv/C5rFpVSebx51re9g8
	5p0M9Hg58TebR9+WVYwenzfJBXBHcdmkpOZklqUW6dslcGWcfHibpaCVs2Ll0RlMDYwn2bsY
	OTkkBEwklny8D2WLSVy4t56ti5GLQ0hgKaPEzMeH2GCKOlrawWwhgemMEtN7WCDsfiaJ9z3i
	IDaLgKrEmtdbmEBsNgENie+fNzOD2CJAQ2/P6WQGGcos8JNJonnFE7CEsEC4RPv8eawgNq+A
	q8SU7+2MEMtsJFbvXMcMEReU+DH5HtgyZgEtic3bmlghbHmJzWveMkPU93JIbLsQA3GEgMS3
	yYeA6jmA4rISmw5AlUhKHFxxg2UCo8gsJFNnIZk6C8nUBYzMqxhFUwuSC4qT0osM9YoTc4tL
	89L1kvNzNzECo/n0v2e9OxhvH7A+xJgMtHIis5Rocj4wGeSVxBsamxlZmJqYGhuZW5qRJqwk
	zpv0MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2ONvfZe3g/hYtwT/xXt4Tfbs8OkyiJt
	5p5LCzWeSv3dOePCjv5znz+sVFgvb+yyIfQEy4eADK//h1/1d9f5cxSxZHhFv8ns3aL8nU1v
	/dndu1yk2ot7bT4py8cxH42x7qy1MjifuOeFUBGL5SrJfV0T/pmkvijhqgnw5Y+KljrUJMm3
	U3OTtxJLcUaioRZzUXEiAB8SGc/8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQd3Eu0+DDX6t1LS4cvEQk8XUh0/Y
	LP5NucFucf3Lc1aL+UfOsVr0v1nIanHu1UpGi/tfjzJafLvSwWRxedccNoul1y8yWSx/+5/N
	YsL0tSwWrXuPsFuc7mZ14PfY8LmJzWPNvDWMHpf7epk8ds66y+6xcvkXNo9NqzrZPO5c28Pm
	Me9koMfLib/ZPPq2rGL0+LxJLoA7qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DS
	wlxJIS8xN9VWycUnQNctMwfoFyWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmgg
	YQ1jxsmHt1kKWjkrVh6dwdTAeJK9i5GTQ0LARKKjpZ0NwhaTuHBvPZgtJDCdUWJ6DwuE3c8k
	8b5HHMRmEVCVWPN6CxOIzSagIfH982ZmEFsEqPf2nE4gm4uDWeAnk0TziidgCWGBcIn2+fNY
	QWxeAVeJKd/bGSGW2Uis3rmOGSIuKPFj8j2wZcwCWhKbtzWxQtjyEpvXvGWewMg3C0nZLCRl
	s5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnCyeSe9gXNVgcYhRgINRiYd3hc3T
	YCHWxLLiytxDjBIczEoivMHngEK8KYmVValF+fFFpTmpxYcYTYHensgsJZqcD0xkeSXxhsYm
	ZkaWRuaGFkbG5krivAdbrQOFBNITS1KzU1MLUotg+pg4OKUaGBl5TacF/dgVckzQxj9YvnRO
	ieUa2QvHZKLeOtpKL3h6T5nvmLBCvPx5ZengM4vNtjtfX29TE7J3wvQn337sO7Xsu7oJa6Lw
	4eq3yhcFz6or7GOdveX0Kv+FT6aGRe51Fc/yYhOu/C8bGJKx/5DkDzvbzpVHJ782eGNekuK/
	StU9ZX/EuY4PKkosxRmJhlrMRcWJAA7UhrksAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch update DT binding to support INn_MODE init_data

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 5c7e723..c21a30e 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -42,6 +42,11 @@ Optional properties:
     the chip default will be used.  If present exactly five values must
     be specified.
 
+  - wlf,inmode : A list of INn_MODE register values. If absent, INn_MODE register
+    set to 0 by default. The size of this list depends on ARIZONA_MAX_INPUT values.
+    ARIZONA_MAX_INPUT is defined in include/linux/mfd/arizona/pdata.h. If present,
+    exactly ARIZONA_MAX_INPUT values must be specified.
+
   - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
     they are being externally supplied. As covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
-- 
2.0.0.390.gcb682f8
