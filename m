Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab3FAHaT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 03:30:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43348 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3FAHaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 03:30:08 -0400
X-AuditID: cbfee68f-b7f436d000000f81-3a-51a9a2ff0833
From: Jingoo Han <jg1.han@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "'Jiri Slaby'" <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] tty: replace strict_strtoul() with kstrtoul()
Date: Sat, 01 Jun 2013 16:30:06 +0900
Message-id: <001301ce5e99$d6e60890$84b219b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5embmJY/DFsKXtTLe2WlpgB4HffQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t8zQ93/i1YGGiw8JGDRvHg9m8XlhZdY
	LT7/3sVqcXnXHDYHFo/9c9ewe/RtWcXocWbBEXaPz5vkAliiuGxSUnMyy1KL9O0SuDKO7m9i
	K9jJUfF92UOWBsaPbF2MnBwSAiYSf281M0LYYhIX7q0HinNxCAksY5SY8fY6C0xR14vlTBCJ
	6YwSfyfvYoFwfjFKTLo7hxmkik1ATeLLl8PsILaIgLFE/9lZYDazQLLEkgfPmEBsYQE7ibOL
	loOtZhFQlVh27g9YnFfAUuLHj5UsELagxI/J91ggerUk1u88zgRhy0tsXvOWGeIiBYkdZ18z
	QuzSA6pZD7VLRGLfi3eMIMdJCKxjl5g/axYzxDIBiW+TDwEN5QBKyEpsOgA1R1Li4IobLBMY
	xWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYyQSOvfwXj3gPUh
	xmSg9ROZpUST84GRmlcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlO
	avEhRiYOTqkGxpxNZ50X3NjHlWr3n+X455fic3PvCSu9Foi9blN8aaVyx5LKzJ+Js+u3r/3Y
	bJroUDg9Vik84eH1+sMsDUK2RiWp095eeKh7/aXi8cRjYb9/ThW2yAhbX717ir/VNNUP36o/
	/3vsNL/GRnNOQdemp7Iz6rVq3meJb/7R4azjFS6a+tnLQsMkU4mlOCPRUIu5qDgRAAMefZDK	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jQd3/i1YGGnz7xmPRvHg9m8XlhZdY
	LT7/3sVqcXnXHDYHFo/9c9ewe/RtWcXocWbBEXaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzju5vYivYyVHxfdlDlgbGj2xdjJwcEgImEl0vljNB2GISF+6t
	B4pzcQgJTGeU+Dt5FwuE84tRYtLdOcwgVWwCahJfvhxmB7FFBIwl+s/OArOZBZIlljx4BjZJ
	WMBO4uyi5WAbWARUJZad+wMW5xWwlPjxYyULhC0o8WPyPRaIXi2J9TuPM0HY8hKb17xlhrhI
	QWLH2deMELv0gGrWQ+0Skdj34h3jBEaBWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERzHz6R3MK5qsDjEKMDBqMTDa7BiRaAQa2JZcWXuIUYJDmYlEd6VC1YG
	CvGmJFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MMXklcQbGpuYGVkamVkYmZibkyasJM57sNU6
	UEggPbEkNTs1tSC1CGYLEwenVAOjfqzP81T9m9bpYn5/Vu3UfX7jzbyrD2ae99hc8fhvp46B
	vBvD0652jaAlr8JdLi3w+lFu212/h+njpg/amx7dXWr7Xeb6DIb13H8vB3vu4XQPYPn0Q27y
	zLt9XIGzn8SvqWy+bbnrElPUzq9cmsuO3t39PZbx/YOsoljuvJWPbRg6fcMvOddtVWIpzkg0
	1GIuKk4EAIqO1yknAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/tty/hvc/hvc_iucv.c |    2 +-
 drivers/tty/sysrq.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
index b6f7d52..9d47f50 100644
--- a/drivers/tty/hvc/hvc_iucv.c
+++ b/drivers/tty/hvc/hvc_iucv.c
@@ -1328,7 +1328,7 @@ out_error:
  */
 static	int __init hvc_iucv_config(char *val)
 {
-	 return strict_strtoul(val, 10, &hvc_iucv_devices);
+	 return kstrtoul(val, 10, &hvc_iucv_devices);
 }
 
 
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index b51c154..5f68f2c 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -932,7 +932,7 @@ static int sysrq_reset_seq_param_set(const char *buffer,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buffer, 0, &val);
+	error = kstrtoul(buffer, 0, &val);
 	if (error < 0)
 		return error;
 
-- 
1.7.10.4


