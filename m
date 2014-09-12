Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaILCK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 22:10:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24192 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaILCKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 22:10:23 -0400
X-AuditID: cbfee68e-f79536d000000fd1-ad-5412560ccf56
From: Chanho Park <chanho61.park@samsung.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org
Cc: linux-kernel@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH] perf tools: define _DEFAULT_SOURCE for glibc_2.20
Date: Fri, 12 Sep 2014 11:10:17 +0900
Message-id: <1410487817-13403-1-git-send-email-chanho61.park@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsWyRsSkWJc3TCjEYOJXZouLbRfZLLru7WCz
	uLxf2+LyrjlsFpcOLGCyWHNkMbsDm8eVpxwem1Z1snm833eVzWPurj5Gj74tqxg9Pm+SC2CL
	4rJJSc3JLEst0rdL4Mp4232dueAya8WJ2TtZGhjvsHQxcnJICJhIHFhygxHCFpO4cG89Wxcj
	F4eQwFJGibt7NrLDFM2cc5YRIjGdUWLqjQVgCSGBNiaJk1MtQWw2AV2JLc9fgU0SEfCX2Ns4
	kRnEZhbwlPjb+hesXljASeLljNVAcQ4OFgFViStT40DCvEAlr/5cYIPYJSdx8thkVpBdEgL/
	2SRmLV8K1ssiICDxbfIhFpBeCQFZiU0HmCHqJSUOrrjBMoFRcAEjwypG0dSC5ILipPQiI73i
	xNzi0rx0veT83E2MwIA9/e9Z3w7GmwesDzEKcDAq8fBWsAiGCLEmlhVX5h5iNAXaMJFZSjQ5
	HxgXeSXxhsZmRhamJqbGRuaWZkrivAlSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MM5w
	vSHcftXuM9uv12qGv2tjklUq5+8+pvuK88gW+wyh/T952pySWZsnV5/fN+/zAiWDb22JEY//
	zd7lvbEssFRPZMWvWyHnVP5tYjtvHr3/suVjjWNM+q8VZ7GG5Rz8aRD8rFBIcKHg1XdLW38s
	W7pj8cvbx6/7bfmk+J9B59uG3XcymjMW1XAqsRRnJBpqMRcVJwIAOYKMAVMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xoC5PmFCIQdNNS4uLbRfZLLru7WCz
	uLxf2+LyrjlsFpcOLGCyWHNkMbsDm8eVpxwem1Z1snm833eVzWPurj5Gj74tqxg9Pm+SC2CL
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6Qkmh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8bb7OnPBZdaKE7N3sjQw3mHp
	YuTkkBAwkZg55ywjhC0mceHeerYuRi4OIYHpjBJTbyxgB0kICbQxSZycagliswnoSmx5/gqs
	QUTAX2Jv40RmEJtZwFPib+tfsHphASeJlzNWA8U5OFgEVCWuTI0DCfMClbz6c4ENYpecxMlj
	k1knMHIvYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcD8+kdzCuarA4xCjAwajEw1vJ
	IhgixJpYVlyZe4hRgoNZSYS3yV8oRIg3JbGyKrUoP76oNCe1+BCjKdDyicxSosn5wFjNK4k3
	NDYxM7I0Mje0MDI2VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAuEpdUf3rkXlfP7AyTV43
	TWBjdYr5HvNF06avTb1TKfLrmeDBW7tfc3+7eK/yg989g/7TAm+KiyyWB5+odL8Q4n7vqoHX
	1W/Z/vbzTN9mB3J8iS2c1v03+VJnxa+nhrrVr/reLLH3sE93382wLvzUJ40jyQ+/id7gqrkX
	Ju/xsGOPWWLJq0UXVyqxFGckGmoxFxUnAgBKODIinQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_BSD_SOURCE was deprecated in favour of _DEFAULT_SOURCE since glibc
2.20[1]. To avoid build warning on glibc2.20, _DEFAULT_SOURCE should
also be defined.

[1]: https://sourceware.org/glibc/wiki/Release/2.20

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 tools/perf/util/util.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 6686436..333d9d1 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -39,6 +39,8 @@
 
 #define _ALL_SOURCE 1
 #define _BSD_SOURCE 1
+/* glibc 2.20 deprecates _BSD_SOURCE in favour of _DEFAULT_SOURCE */
+#define _DEFAULT_SOURCE 1
 #define HAS_BOOL
 
 #include <unistd.h>
-- 
1.9.1

