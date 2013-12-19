Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3LSIug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:50:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:52546 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3LSIuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:50:32 -0500
X-AuditID: cbfee68f-b7fe36d0000016f8-58-52b2b3506629
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: add description about small_discards in document
Date: Thu, 19 Dec 2013 17:49:13 +0900
Message-id: <1387442953-13476-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zA92AzZuCDGbdk7e4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PNmuVMBd2cFSde
	7GNsYLzP1sXIySEhYCKxclcfM4QtJnHh3nqgOBeHkMAyRokLp06wwBTNmPYArEFIYBGjxJHl
	phB2M5PE42P5XYwcHGwC2hKb9xuAhEUEmCUWTD3PCDKHWWACo8T/Re/B5ggLuEuc3XCOEcRm
	EVCVeHhqFTNILy9Q/P8lSYhV2hLbnk8E65UQuM0m8WnjKWaIegGJb5MPsYDUSwjISmw6AHWz
	pMTBFTdYJjAKLmBkWMUomlqQXFCclF5krFecmFtcmpeul5yfu4kREn79OxjvHrA+xJgMNG4i
	s5Rocj4wfPNK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4ECMT
	B6dUA6MNk1G137I1Vju6Dr+OiJ34WEvG06jvxF8/KVW+iQUXp4hKOqY+c1J99z0zfbNgxS1X
	nfuHGYXu/nhsl8m677/065PpzsEqp7ceO2aVqaH6h7ffZ86JJb3zj/pcYGR6Lbvpw5XG7Wa9
	5UHsYacNYlZ99PLinTK7mEnMykRNiSX8zHfDMOcT25VYijMSDbWYi4oTAdW83cVVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jAd2AzZuCDLY/kba4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHjzZrlTAXdnBUnXuxjbGC8z9bFyMkhIWAiMWPaAyhbTOLCvfVgtpDAIkaJ
	I8tNIexmJonHx/K7GDk42AS0JTbvNwAJiwgwSyyYep6xi5GLg1lgAqPE/0XvWUASwgLuEmc3
	nGMEsVkEVCUenlrFDNLLCxT/f0kSYpW2xLbnExknMHIvYGRYxSiaWpBcUJyUnmukV5yYW1ya
	l66XnJ+7iREc3M+kdzCuarA4xCjAwajEwxvwfGOQEGtiWXFl7iFGCQ5mJRFezeWbgoR4UxIr
	q1KL8uOLSnNSiw8xJgMtn8gsJZqcD4y8vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeW
	pGanphakFsFsYeLglGpgVM0M0FWYKXvA8UTZDIHWf99mMcxSzGpt5Vn+azHXJB/PE2nHb1iK
	Nda+Cj+/mplbhkNbyvH9i5ebVs8+vX9XkpN5SUa4i72rU/SZV8X2C/tcOI+XZmfPkFdymrSA
	aRZr2+71R8wirSfenyPD3bTFW6h0WoBUyuw+p0WaCQxX17w6vMEx5SC/EktxRqKhFnNRcSIA
	cV2cvbICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a description about small_disacrds in the f2fs document.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 Documentation/filesystems/f2fs.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index 6de2102..1073970 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -173,6 +173,12 @@ Files in /sys/fs/f2fs/<devname>
 			      conduct checkpoint to reclaim the prefree segments
 			      to free segments. By default, 100 segments, 200MB.
 
+ max_small_discards	      This parameter controls the number of discard
+			      commands that consist small blocks less than 2MB.
+			      The candidates to be discarded are cached until
+			      checkpoint is triggered, and issued during the
+			      checkpoint. By default, it is disabled with 0.
+
  ipu_policy                   This parameter controls the policy of in-place
                               updates in f2fs. There are five policies:
                                0: F2FS_IPU_FORCE, 1: F2FS_IPU_SSR,
-- 
1.8.4.474.g128a96c

