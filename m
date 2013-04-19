Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967761Ab3DSA7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 20:59:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59604 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967716Ab3DSA7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 20:59:06 -0400
X-AuditID: cbfee690-b7f656d0000007e3-e4-517096d5617d
From: Woosung Lee <wstar.lee@samsung.com>
To: linux-kernel@vger.kernel.org, mmarek@suse.cz
Cc: js1304@gmail.com
Subject: [PATCH 1/1] scripts/tags.sh: Support SUBPLAT for ARM
Date: Fri, 19 Apr 2013 09:59:00 +0900
Message-id: <001701ce3c99$147f8f50$3d7eadf0$%lee@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac48mRRSF6/axYUPSrukvojsf0BVtw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t8zfd2r0woCDSZ3GFnM3DuX1eLyrjls
	Fi37LjA5MHvsnHWX3ePMgiPsHp83yQUwR3HZpKTmZJalFunbJXBlPLiYX/CUo2JRwwmmBsan
	bF2MnBwSAiYSV/ZuZ4GwxSQu3FsPFOfiEBJYxigxf80KVpiiz7/vs4PYQgKLGCXm7lWFKPrL
	KPH/zT2wBJuApsS/j3/BGkQEDCQe7D/PDGIzC4hITH3SAmYLC9hKNDyfALaZRUBVYndLO5jN
	CxT/1v2WHcIWlPgx+R4LRK+WxPqdx5kgbHmJzWveAs3hADpIXeLRX12IVXoSe2e3MMGs2vfi
	HSPIbRIC09klXi/vZYTYJSDxbfIhFoheWYlNB5gh/pKUOLjiBssERrFZSDbPQrJ5FpLNs5Cs
	WMDIsopRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjJJ4m7GC8d8D6EGMy0PqJzFKiyfnAeMwr
	iTc0NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+NsUW2d
	tUen5d+cfca70TT58vw+QeXqPd/8wycw/rNNDd9lxeV6zWKCzOYTQnxVizIfL/h772j2zKyY
	7kDjSI4/06ImxNhluPPOuntuZpGwH+e5I/0L1v/+m/HgbVTr42T+rdnSPQbHvhS65d5Xk2dY
	u67l/uQwD12Fn8d/a4joHW7dydZ5MlWJpTgj0VCLuag4EQBRiCw0vQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xgO7VaQWBBjvX61nM3DuX1eLyrjls
	Fi37LjA5MHvsnHWX3ePMgiPsHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZjy4mF/wlKNiUcMJpgbGp2xdjJwcEgImEp9/32eHsMUkLtxbDxYXEljEKDF3r2oX
	IxeQ/ZdR4v+be2BFbAKaEv8+/mUFsUUEDCQe7D/PDGIzC4hITH3SAmYLC9hKNDyfADaIRUBV
	YndLO5jNCxT/1v2WHcIWlPgx+R4LRK+WxPqdx5kgbHmJzWveAs3hADpIXeLRX12IVXoSe2e3
	MMGs2vfiHeMERoFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR
	HK3PpHYwrmywOMQowMGoxMPbIFEQKMSaWFZcmXuIUYKDWUmEd3oSUIg3JbGyKrUoP76oNCe1
	+BBjMtCjE5mlRJPzgYkkryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBb
	mDg4pRoYpQ8fOJPEJcrenj/97Vy+Y8rMVeXH3i1jr1i09lew3tIdmU3HWFRWrtuiufm47mZO
	W8Or3mlrm/4p8FWUtLU+/7VEXf7UwXnix+b/Eqm10As/LvpiYuqTV4K9q0zklJQX37weqBvb
	L+K67VCjRV9TyenYW4YJucK8v2zVEhb92hQo8ETxeGmaEktxRqKhFnNRcSIAQ5cDAhoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many subarch on ARM, and each subarch use their vendor's
platform code. Typical name of platform code use their product
series or vendor name.

This patch support SUBPLAT for platform code.

Signed-off-by: Woosung Lee <wstar.lee@samsung.com>
Cc: Joonsoo Kim <js1304@gmail.com>
---
 scripts/tags.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 26a87e6..b609d1e 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -276,7 +276,7 @@ if [ "${ARCH}" = "um" ]; then
 	else
 		archinclude=${SUBARCH}
 	fi
-elif [ "${SRCARCH}" = "arm" -a "${SUBARCH}" != "" ]; then
+elif [ "${SRCARCH}" = "arm" -a "${SUBARCH}" != "" -o "${SUBPLAT}" != "" ];
then
 	subarchdir=$(find ${tree}arch/$SRCARCH/ -name "mach-*" -type d -o \
 							-name "plat-*" -type
d);
 	for i in $subarchdir; do
@@ -285,6 +285,8 @@ elif [ "${SRCARCH}" = "arm" -a "${SUBARCH}" != "" ];
then
 				;;
 			*"plat-"${SUBARCH})
 				;;
+			*"plat-"${SUBPLAT})
+				;;
 			*)
 				subarchprune="$subarchprune \
 						-wholename $i -prune -o"
-- 
1.7.9.5

