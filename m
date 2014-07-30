Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaG3A4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:56:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53118 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbaG3A4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:56:33 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-51-53d842b817a4
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Wim Van Sebroeck <wim@iguana.be>, Randy Dunlap <rdunlap@infradead.org>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-watchdog@vger.kernel.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org, again4you@gmail.com,
        Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH v2] Documentation: fix two typos in watchdog-api.txt
Date: Wed, 30 Jul 2014 09:56:21 +0900
Message-id: <1406681781-3533-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWyRsSkWHeH041gg2dfNSxO9vezWFzeNYfN
	4sa6fewWTxaeYbJ4e2c6i8WCPSUW7/dfZrK4NeMFqwOHx85Zd9k9rm0W89i8Qstj06pONo+d
	3xvYPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj7/83rAW/2SverjjJ2MB4iq2LkZNDQsBE
	4l7fWSYIW0ziwr31QHEuDiGBpYwSF+YvYYUpmn/vEBNEYhGjxORli1ggnDYmiTddt8BGsQno
	Sjw5cJm5i5GDQ0TAS2L/1QSQGmaBXYwS56/MYAGpERZwkZg1bRXYOhYBVYklT4+CxXkF3CX2
	ntgK1ishoCAxZ5INxOLJ7BJLtxpDlAtIfJt8iAWiRFZi0wFmiBJJiYMrbrBMYBRcwMiwilE0
	tSC5oDgpvchIrzgxt7g0L10vOT93EyMwmE//e9a3g/HmAetDjMlA4yYyS4km5wOjIa8k3tDY
	zMjC1MTU2Mjc0ow0YSVx3kUPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MDKGCFezrXyu
	aaM968a2xSvmsv99ZzvV8OCaYweCWqzsMm1zSj6nP9rI9d7MT3wa6zK1wI3hnkZSFguvewdP
	Uv2+cuH098tua02LOr57mlyTySSBmm2cxnyePzrelyz653Nk2qG5wYV7vO/JblsicebNjYwL
	WVb3N022/vmYXdTh/417wVk/EkKVWIozEg21mIuKEwHMysEkfAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t9jAd0dTjeCDbrfK1qc7O9nsbi8aw6b
	xY11+9gtniw8w2Tx9s50FosFe0os3u+/zGRxa8YLVgcOj52z7rJ7XNss5rF5hZbHplWdbB47
	vzewe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjL//
	37AW/GaveLviJGMD4ym2LkZODgkBE4n59w4xQdhiEhfurQeKc3EICSxilJi8bBELhNPGJPGm
	6xZYB5uArsSTA5eZuxg5OEQEvCT2X00AqWEW2MUocf7KDBaQGmEBF4lZ01aBTWURUJVY8vQo
	WJxXwF1i74mtYL0SAgoScybZTGDkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOFqe
	Se9gXNVgcYhRgINRiYd3xv/rwUKsiWXFlbmHGCU4mJVEeL/K3QgW4k1JrKxKLcqPLyrNSS0+
	xGgKtHwis5Rocj4wkvNK4g2NTcyMLI3MDS2MjM2VxHkPtloHCgmkJ5akZqemFqQWwfQxcXBK
	NTD2Je63uCjuG9KusfSHftr07Z/DzVWYjfsWLDg0+agzM5f8Yp66H7vFX4ZWbDjovkHY9G7k
	1cf7uIMYhNcdfOlnqvGAt9RKwea+53eV6eUBpberZku8vdC2h3uu+//20jd/P63w11YKC9/7
	lCeWR3/rD+nlvJpi/6trL7Q6+3B126Yfnxkwbb4SS3FGoqEWc1FxIgDeIqKDrAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes 'go of' to 'go off' and 'pretimout' to
'pretimeout'.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---
 Documentation/watchdog/watchdog-api.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/watchdog/watchdog-api.txt b/Documentation/watchdog/watchdog-api.txt
index eb7132e..b3a701f 100644
--- a/Documentation/watchdog/watchdog-api.txt
+++ b/Documentation/watchdog/watchdog-api.txt
@@ -118,7 +118,7 @@ resets.
 Note that the pretimeout is the number of seconds before the time
 when the timeout will go off.  It is not the number of seconds until
 the pretimeout.  So, for instance, if you set the timeout to 60 seconds
-and the pretimeout to 10 seconds, the pretimout will go of in 50
+and the pretimeout to 10 seconds, the pretimeout will go off in 50
 seconds.  Setting a pretimeout to zero disables it.
 
 There is also a get function for getting the pretimeout:
-- 
1.7.9.5

