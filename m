Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaBDJ6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:58:37 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37609 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbaBDJ6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:58:01 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-83-52f0b9a7b34a
From: Amit Grover <amit.grover@samsung.com>
To: linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kyungmin.park@samsung.com, k.debski@samsung.com,
        prabhakar.csengg@gmail.com, s.nawrocki@samsung.com,
        hans.verkuil@cisco.com, hverkuil@xs4all.nl, swaminath.p@samsung.com
Cc: jtp.park@samsung.com, Rrob@landley.net, andrew.smirnov@gmail.com,
        anatol.pomozov@gmail.com, jmccrohan@gmail.com, joe@perches.com,
        awalls@md.metrocast.net, arun.kk@samsung.com, amit.grover@samsung.com,
        austin.lobo@samsung.com
Subject: [PATCH 1/2] [media] v4l2: Add settings for Horizontal and Vertical MV
 Search Range
Date: Tue, 04 Feb 2014 15:29:58 +0530
Message-id: <1391507999-31437-2-git-send-email-amit.grover@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391507999-31437-1-git-send-email-amit.grover@samsung.com>
References: <52E0ED10.2020901@samsung.com>
 <1391507999-31437-1-git-send-email-amit.grover@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkSnf5zg9BBj+6lC2e9X1itXjZW2jR
	3GFr8fHUbVaL+Z9usli8aU+yWPJzF5PFqcnPmCz6H61ntJh9/zGLxZG1V5ksfry+wGZxtukN
	u8Wmx9dYLRa2LWGxuLxrDptFz4atQMPur2C2ePrqOZvF4TftrBZtXVMZHUQ9pvzeyOqxc9Zd
	do9Xq2eyemxeUu8x68Jmdo8vq64xe/RtWcXo8XmTnMepr5/ZAzijuGxSUnMyy1KL9O0SuDLW
	n1zEVLBYvuLy12fMDYy3pboYOTkkBEwkruz+zAxhi0lcuLeerYuRi0NIYCmjxJKXLxi7GDnA
	ih7Ot4GIT2eUWLv3JFRRD5PEyc1NLCDdbALaEttnLAdLiAhsYJJ42H2RHcRhFnjFKHFs8gpm
	kFHCArESWy4VgDSwCKhKzG//ywhi8wq4S7yZvpsJYpuCxJxJNiBhTgEPiRN7LzCB2EICGRLv
	jl8Cmy8hMJdDYtbCPhaIOQIS3yYfYoHolZXYdADqG0mJgytusExgFF7AyLCKUTS1ILmgOCm9
	yFSvODG3uDQvXS85P3cTIzAmT/97NnEH4/0D1ocYk4HGTWSWEk3OB8Z0Xkm8obGZkYWpiamx
	kbmlGWnCSuK86Y+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwTvxy3PHS9AdPnkh0y5Yt
	OrAgU8qgn0vQrqT2y+mlxbN7/IrNLz/x3rfexvnNBm+rndtOTo7aHJMd+6NJVELh3q1z55by
	+wTyXf2ZJLx6ip3JttgU7UXKJz97cohUetg9NhTuvbxlutC/VsunZ/+XzZ85+aLBkvRJlm8i
	1rpEbPLTuPHr068vh5VYijMSDbWYi4oTAV7OpyffAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd3lOz8EGTyeJW7xrO8Tq8XL3kKL
	5g5bi4+nbrNazP90k8XiTXuSxZKfu5gsTk1+xmTR/2g9o8Xs+49ZLI6svcpk8eP1BTaLs01v
	2C02Pb7GarGwbQmLxeVdc9gsejZsBRp2fwWzxdNXz9ksDr9pZ7Vo65rK6CDqMeX3RlaPnbPu
	snu8Wj2T1WPzknqPWRc2s3t8WXWN2aNvyypGj8+b5DxOff3MHsAZ1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0nZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsIYxY/3JRUwFi+UrLn99xtzAeFuqi5GDQ0LAROLhfJsuRk4g
	U0ziwr31bF2MXBxCAtMZJdbuPQnl9DBJnNzcxAJSxSagLbF9xnKwhIjABiaJh90X2UEcZoFX
	jBLHJq9gBhkrLBArseVSAUgDi4CqxPz2v4wgNq+Au8Sb6buZIDYrSMyZBLaZU8BD4sTeC0wg
	tpBAhsS745fYJjDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHPHPpHYwrmywOMQo
	wMGoxMOroPIhSIg1say4MvcQowQHs5IIr/k2oBBvSmJlVWpRfnxRaU5q8SHGZKCjJjJLiSbn
	A5NRXkm8obGJuamxqaWJhYmZJWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwno3f9s0z
	6VFLvp13wC+Wb/xp22QDF+sfF/5650N98uavr1Y+NNNiO878tLnm62QF84p3sj/P1P44szRl
	0szCpX4MtvyvljYoGEqcWWA6Z21pJHO2MO/DIi+Fkl/bRBQO7WUNvvHqVI1E/N4rzgrTV3Tn
	v7/h2rvx3C5ruc/C7K2a3ondnie4lFiKMxINtZiLihMBunxYJzwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding V4L2 controls for horizontal and vertical search range in pixels
for motion estimation module in video encoder.

Signed-off-by: Swami Nathan <swaminath.p@samsung.com>
Signed-off-by: Amit Grover <amit.grover@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   20 ++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |    6 ++++++
 include/uapi/linux/v4l2-controls.h           |    2 ++
 3 files changed, 28 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index a5a3188..0e1770c 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2258,6 +2258,26 @@ Applicable to the MPEG1, MPEG2, MPEG4 encoders.</entry>
 VBV buffer control.</entry>
 	      </row>
 
+		  <row><entry></entry></row>
+	      <row id=""v4l2-mpeg-video-hor-search-range">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+		<row><entry spanname="descr">Horizontal search range defines maximum horizontal search area in pixels
+to search and match for the present Macroblock (MB) in the reference picture. This V4L2 control macro is used to set
+horizontal search range for motion estimation module in video encoder.</entry>
+	      </row>
+
+		 <row><entry></entry></row>
+	      <row id="v4l2-mpeg-video-vert-search-range">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+		<row><entry spanname="descr">Vertical search range defines maximum vertical search area in pixels
+to search and match for the present Macroblock (MB) in the reference picture. This V4L2 control macro is used to set
+vertical search range for motion estimation module in video encoder.</entry>
+	      </row>
+
 	      <row><entry></entry></row>
 	      <row>
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE</constant>&nbsp;</entry>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 6ff002b..e9e12c4 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -735,6 +735,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_DEC_PTS:			return "Video Decoder PTS";
 	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:			return "Video Decoder Frame Count";
 	case V4L2_CID_MPEG_VIDEO_VBV_DELAY:			return "Initial Delay for VBV Control";
+	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:		return "Horizontal MV Search Range";
+	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		return "Vertical MV Search Range";
 	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
 
 	/* VPX controls */
@@ -910,6 +912,10 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*min = 0;
 		*max = *step = 1;
 		break;
+	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:
+	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		break;
 	case V4L2_CID_PAN_RESET:
 	case V4L2_CID_TILT_RESET:
 	case V4L2_CID_FLASH_STROBE:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2cbe605..cda6fa0 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -376,6 +376,8 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_DEC_FRAME			(V4L2_CID_MPEG_BASE+224)
 #define V4L2_CID_MPEG_VIDEO_VBV_DELAY			(V4L2_CID_MPEG_BASE+225)
 #define V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER		(V4L2_CID_MPEG_BASE+226)
+#define V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+227)
+#define V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+228)
 
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
-- 
1.7.9.5

