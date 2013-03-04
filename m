Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3CDICs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:02:48 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32680 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab3CDICq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:02:46 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-45-513455232c7f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 13/24] rtc: rtc-mv: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:02:42 +0900
Message-id: <014601ce18ae$a6210100$f2630300$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAALPFw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zfV3lUJNAg+5mNYslF6+yW8xZv4bN
	4vLCS6wWl3fNYbPY39nB6MDqsWfiSTaPEzN+s3j0bVnF6DF93k8mj8+b5AJYo7hsUlJzMstS
	i/TtErgynp2ZwFjQy15xt/MxWwNjC1sXIweHhICJxLeFol2MnECmmMSFe+uBwlwcQgLLGCXm
	bL3ACpEwkXh7rIEZIjGdUeJv/1kWCOcXo8Tv3glgVWwCahJfvhxmB5kqIqAv0daiAVLDLNDL
	KHGmdzc7SI2QgK3El4cPmEBsTgE7ifvnVoH1Cgu4Sbzs+gIWZxFQlWjvbWUBsXmB6u88b2eG
	sAUlfky+BxZnFtCSWL/zOBOELS+xec1bZohv1CUe/dUFCYsIGElsvr+cFaJERGLfi3eMIPdI
	CNxjl/i9aQE7xC4BiW+TD7FA9MpKbDrADPGwpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZV
	jKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCGR2reD8eYB60OMyUDrJzJLiSbnAyM9ryTe0NjY
	xMzE1MTc0tTclDRhJXFe+UsygUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY9bLeP2WPZxf8
	YMqzbqfYJ47csNCC5n0Wp8PFmxkn15U0Sy/9JOTdV6iYyFQptvHNuTnFR7qv+yXl6E47fO3P
	3CCXgLmsGuvuH31rsm1eWOui0MyZXypmfpLhPPRExi/0rutJ15sLdlsYPvRtW6+nrcp16Kk8
	g9h9/0kc7zcsi09PmWBpYaigxFKckWioxVxUnAgAgmlZw+oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQV3lUJNAg0P/FS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHh2ZgJjQS97xd3Ox2wNjC1sXYycHBICJhJv
	jzUwQ9hiEhfurQeKc3EICUxnlPjbf5YFwvnFKPG7dwIrSBWbgJrEly+H2bsYOThEBPQl2lo0
	QGqYBXoZJc707mYHqRESsJX48vABE4jNKWAncf/cKrBeYQE3iZddX8DiLAKqEu29rSwgNi9Q
	/Z3n7cwQtqDEj8n3wOLMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxOb7y1khSkQk
	9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEJ4Jn
	0jsYVzVYHGIU4GBU4uEV+GQcKMSaWFZcmXuIUYKDWUmEt0zCJFCINyWxsiq1KD++qDQntfgQ
	YzLQoxOZpUST84FJKq8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBx
	cEo1MKavP+THm9rOePWG2u/7St66sZxrlwZ2VMTxCFy0MDLV5IvyfZBi6f3z8d1ZZ5MfhZsE
	p/A0LE+elOhmrX+Xn9n7p23RoYq3jAvLQ5fU/JdQn2DsZzNDpU9q+bLsGxrBx+puqbIFeD4Q
	q+21b5UR6M///rR15veruyXWvWG8tCrwTXN7hDaLEktxRqKhFnNRcSIAzNKjbkgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-mv.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
index 59d1671..1583d62 100644
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -311,18 +311,7 @@ static struct platform_driver mv_rtc_driver = {
 	},
 };
 
-static __init int mv_init(void)
-{
-	return platform_driver_probe(&mv_rtc_driver, mv_rtc_probe);
-}
-
-static __exit void mv_exit(void)
-{
-	platform_driver_unregister(&mv_rtc_driver);
-}
-
-module_init(mv_init);
-module_exit(mv_exit);
+module_platform_driver_probe(mv_rtc_driver, mv_rtc_probe);
 
 MODULE_AUTHOR("Saeed Bishara <saeed@marvell.com>");
 MODULE_DESCRIPTION("Marvell RTC driver");
-- 
1.7.2.5


