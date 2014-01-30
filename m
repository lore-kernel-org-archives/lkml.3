Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaA3Fku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 00:40:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51262 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaA3Fko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 00:40:44 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-6d-52e9e5dbbc46
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
Subject: [PATCH v2 1/2] drivers/media: v4l2: Add settings for Horizontal and
 Vertical MV Search Range
Date: Thu, 30 Jan 2014 11:12:42 +0530
Message-id: <1391060563-27015-2-git-send-email-amit.grover@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391060563-27015-1-git-send-email-amit.grover@samsung.com>
References: <52E0ED10.2020901@samsung.com>
 <1391060563-27015-1-git-send-email-amit.grover@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkWvf205dBBusbZSye9X1itXjZW2jR
	3GFr8fHUbVaL+Z9usli8aU+yWPJzF5PFqcnPmCz6H61ntJh9/zGLxZG1V5ksfry+wGZxtukN
	u8Wmx9dYLRa2LWGxuLxrDptFz4atQMPur2C2ePrqOZvF4TftrBZtXVMZHUQ9pvzeyOqxc9Zd
	do9Xq2eyemxeUu8x68Jmdo8vq64xe/RtWcXo8XmTnMepr5/ZAzijuGxSUnMyy1KL9O0SuDI+
	L7zJVLBDoWL9vR1sDYyHpbsYOTkkBEwk5j7tZYGwxSQu3FvP1sXIxSEksJRR4nnHITaYotlX
	ljBCJBYxSpzq7WKGcHqYJFqPfWQGqWIT0JbYPmM5WLuIwAYmiYfdF9lBHGaBV4wSxyavAKsS
	FkiX+H55GzuIzSKgKjHz4g2w5bwC7hJr1l5m7WLkANqnIDFnkg1ImFPAQ+Lu/zeMILaQQIbE
	s5ZrrCAzJQQWcki8ndTNCjFHQOLb5EMsEL2yEpsOMEOcLSlxcMUNlgmMwgsYGVYxiqYWJBcU
	J6UXmeoVJ+YWl+al6yXn525iBMbl6X/PJu5gvH/A+hBjMtC4icxSosn5wLjOK4k3NDYzsjA1
	MTU2Mrc0I01YSZw3/VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGVCneygfre5vXMfFd
	28OpPY3ZUD12o93E3yv/l2fsWbw2h+VXaOSD504/ozNPa8b3PJ0WYCEy8fRecz3LB+UvI889
	ERD+sf1E0vqnfNHxpkYMotei17bM8RS0Dq0Xya320mddnFaYoKi4VWhNf1p82/KznF8mL+di
	uLrYcJn11xlJv6W97loqsRRnJBpqMRcVJwIAbimsxOECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAd3bT18GGRzfLmTxrO8Tq8XL3kKL
	5g5bi4+nbrNazP90k8XiTXuSxZKfu5gsTk1+xmTR/2g9o8Xs+49ZLI6svcpk8eP1BTaLs01v
	2C02Pb7GarGwbQmLxeVdc9gsejZsBRp2fwWzxdNXz9ksDr9pZ7Vo65rK6CDqMeX3RlaPnbPu
	snu8Wj2T1WPzknqPWRc2s3t8WXWN2aNvyypGj8+b5DxOff3MHsAZ1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0nZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsIYx4/PCm0wFOxQq1t/bwdbAeFi6i5GTQ0LARGL2lSWMELaY
	xIV769m6GLk4hAQWMUqc6u1ihnB6mCRaj31kBqliE9CW2D5jOViViMAGJomH3RfZQRxmgVeM
	EscmrwCrEhZIl/h+eRs7iM0ioCox8+INFhCbV8BdYs3ay6xdjBxA+xQk5kyyAQlzCnhI3P3/
	BuwMIYEMiWct11gnMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc9c+kdzCuarA4
	xCjAwajEw7ti8ssgIdbEsuLK3EOMEhzMSiK8cXeBQrwpiZVVqUX58UWlOanFhxiTgY6ayCwl
	mpwPTEh5JfGGxibmpsamliYWJmaWpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cA488Jm
	Wc1fsqcurynUu3Bf6aO2v8VWsd4VKpMZPff1SR/i3XPpRezqGfv3ZHQlxE40nfd9kWXA9OBp
	q9cve6wgaH5ffu3BFUsv7MpquaHII3fAPPBQNY/pjQSVL78rtGb/4J+YtVzSTfeMnGxLsfLZ
	Q75xVQ5yq1+xV9VLprtOfH5X6ppzQ88pJZbijERDLeai4kQAKwGpCz4DAAA=
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
 drivers/media/v4l2-core/v4l2-ctrls.c         |   14 ++++++++++++++
 include/uapi/linux/v4l2-controls.h           |    2 ++
 3 files changed, 36 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 7a3b49b..be04d18 100644
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
index fb46790..e775388 100644
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
@@ -905,6 +907,18 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*min = 0;
 		*max = *step = 1;
 		break;
+	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		*min = 16;
+		*max = 128;
+		*step = 16;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		*min = 16;
+		*max = 128;
+		*step = 16;
+		break;
 	case V4L2_CID_PAN_RESET:
 	case V4L2_CID_TILT_RESET:
 	case V4L2_CID_FLASH_STROBE:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 1666aab..80e1def 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -372,6 +372,8 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_DEC_FRAME			(V4L2_CID_MPEG_BASE+224)
 #define V4L2_CID_MPEG_VIDEO_VBV_DELAY			(V4L2_CID_MPEG_BASE+225)
 #define V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER		(V4L2_CID_MPEG_BASE+226)
+#define V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+227)
+#define V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+228)
 
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
-- 
1.7.9.5

