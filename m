Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaAWFTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 00:19:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24136 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaAWFTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 00:19:22 -0500
X-AuditID: cbfee68f-b7f156d00000276c-07-52e0a6546302
Message-id: <DA6097ED98694425932A6AF93513371A@sisodomain.com>
From: swaminathan <swaminath.p@samsung.com>
To: Amit Grover <amit.grover@samsung.com>, linux-media@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, rob@landley.net,
        kyungmin.park@samsung.com, k.debski@samsung.com, jtp.park@samsung.com
Cc: hans.verkuil@cisco.com, andrew.smirnov@gmail.com, s.nawrocki@samsung.com,
        arun.kk@samsung.com, anatol.pomozov@gmail.com, jmccrohan@gmail.com,
        austin.lobo@samsung.com, hverkuil@xs4all.nl
References: <1388400186-22045-1-git-send-email-amit.grover@samsung.com>
In-reply-to: <1388400186-22045-1-git-send-email-amit.grover@samsung.com>
Subject: Re: [PATCH] [media] s5p-mfc: Add Horizontal and Vertical search range
 for Video Macro Blocks
Date: Thu, 23 Jan 2014 10:49:03 +0530
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=iso-8859-1; reply-type=original
Content-transfer-encoding: 7bit
X-Priority: 3
X-MSMail-priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MIMEOLE: Produced By Microsoft MimeOLE V14.0.8117.416
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsWyRsSkSjdk2YMgg327eSye9X1itXjZW2jR
	3GFr8fHUbVaL+Z9uslgs+bmLyeLU5GdMFv2P1jNaHFl7lcnix+sLbBZnm96wW2x6fI3VYmHb
	EhaLy7vmsFn0bNjKajHj/D4mi3Uvp7NYHH7Tzuog5DHl90ZWj52z7rJ7vFo9k9Vj85J6j74t
	qxg9Pm+S8zj19TN7AHsUl01Kak5mWWqRvl0CV8aVFw9YCybbVuzZvIixgfGgcRcjJ4eEgInE
	sm19rBC2mMSFe+vZuhi5OIQEljJK/DxxhRGmqGHdPlaIxHRGifu3r7CAJIQEfjJK/HmeBWLz
	CthKHH9yBqiIg4NNQFvi0w1GkHoRgRVMEs1L/7GDOMwCBxkl7l2EmCok4C6xfHEHmM0p4CGx
	/s0ydhBbWCBd4v/fI4wgg1gEVCX6bvNAzBeU+DH5HtheZoEAiZUTZzNC2PISm9e8ZYY4lFdi
	RvtTFghbUmJ1zy12iPFCEh1XO6G+NJaY8m8pVL25xMXtm5lAbpMQuMMhcf/tVDaQBIuAgMS3
	yYdYQG6QEJCV2HSAGWbmwRU3WCYwSs1CctIsJCfNQnLSAkbmVYyiqQXJBcVJ6UXGesWJucWl
	eel6yfm5mxiBKeX0v2f9OxjvHrA+xJgMtHIis5Rocj4wJeWVxBsamxlZmJqYGhuZW5qRJqwk
	znv/YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk4pYMwfLmMr8bu3zq+P+xmDrrOsfUlWjsbr
	sNjL8tKnXKawL/YNqZ6wcptphelJn/97inbpCIi1l5hyzDi1+GFdUWBdx7H+uNPGDBt3BE+o
	uc4iXyc2uUYsNiA66qG5eHNkVmDmp5/TH8wN6Tx6qURhhtY83vDjjorBGqJJ64V/S+/6FH2+
	17xBiaU4I9FQi7moOBEAc3Lhlz8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42I5/e+xoG7IsgdBBp/XMFo86/vEavGyt9Ci
	ucPW4uOp26wW8z/dZLFY8nMXk8Wpyc+YLPofrWe0OLL2KpPFj9cX2CzONr1ht9j0+BqrxcK2
	JSwWl3fNYbPo2bCV1WLG+X1MFuteTmexOPymndVByGPK742sHjtn3WX3eLV6JqvH5iX1Hn1b
	VjF6fN4k53Hq62f2APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTc
	VFslF58AXbfMHKAvlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZV148
	YC2YbFuxZ/MixgbGg8ZdjJwcEgImEg3r9rFC2GISF+6tZ+ti5OIQEpjOKHH/9hUWkISQwE9G
	iT/Ps0BsXgFbieNPzgA1cHCwCWhLfLrBCFIvIrCCSaJ56T92EIdZ4CCjxL2LVxghmt0lli/u
	ALM5BTwk1r9Zxg5iCwukS/z/e4QRZBCLgKpE320eiPmCEj8m3wPbyywQILFy4mxGCFteYvOa
	t8wQh/JKzGh/ygJhS0qs7rnFDjFeSKLjaifUM8YSU/4thao3l7i4fTPTBEaRWUhWzEKyYhaS
	FQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBCesZ9I7GFc1WBxiFOBgVOLhTfhyP0iI
	NbGsuDL3EKMEB7OSCG/LtAdBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTKZ5JfGGxibm
	psamliYWJmaWpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cA45xPHjaQv64PVy/KcsiOO
	VL1q/coiN02X6fHkz5v+PjftOnzh7xln8afvtk7l+9y6oH76s3m7PvmoBTvK2HPcPhEiEnhE
	PONH75wijdsch7f+6DGYv+u+kwOPzckbN5/pCd5bv8No8q7lPUwCPI/SIzZtNbAtX8H93CZx
	t+HDJP2dJj5M2yVElFiKMxINtZiLihMBvCcKRJwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
Is there any review Comments for the patch "[PATCH] [media] s5p-mfc: Add 
Horizontal and Vertical search range for Video Macro Blocks"
posted on 30-Dec-2013 ?


Regards,
Swaminathan




--------------------------------------------------
From: "Amit Grover" <amit.grover@samsung.com>
Sent: Monday, December 30, 2013 4:13 PM
To: <m.chehab@samsung.com>; <linux-media@vger.kernel.org>; 
<linux-doc@vger.kernel.org>; <linux-kernel@vger.kernel.org>; 
<linux-arm-kernel@lists.infradead.org>; <linux-samsung-soc@vger.kernel.org>; 
<rob@landley.net>; <kyungmin.park@samsung.com>; <k.debski@samsung.com>; 
<jtp.park@samsung.com>
Cc: <hans.verkuil@cisco.com>; <andrew.smirnov@gmail.com>; 
<s.nawrocki@samsung.com>; <arun.kk@samsung.com>; <anatol.pomozov@gmail.com>; 
<jmccrohan@gmail.com>; <austin.lobo@samsung.com>; "Swami Nathan" 
<swaminath.p@samsung.com>
Subject: [PATCH] [media] s5p-mfc: Add Horizontal and Vertical search range 
for Video Macro Blocks

> This patch adds Controls to set Horizontal and Vertical search range
> for Motion Estimation block for Samsung MFC video Encoders.
>
> Signed-off-by: Swami Nathan <swaminath.p@samsung.com>
> Signed-off-by: Amit Grover <amit.grover@samsung.com>
> ---
> Documentation/DocBook/media/v4l/controls.xml    |   14 +++++++++++++
> drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   24 
> +++++++++++++++++++++++
> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 ++------
> drivers/media/v4l2-core/v4l2-ctrls.c            |   14 +++++++++++++
> include/uapi/linux/v4l2-controls.h              |    2 ++
> 6 files changed, 58 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/DocBook/media/v4l/controls.xml 
> b/Documentation/DocBook/media/v4l/controls.xml
> index 7a3b49b..70a0f6f 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -2258,6 +2258,20 @@ Applicable to the MPEG1, MPEG2, MPEG4 
> encoders.</entry>
> VBV buffer control.</entry>
>        </row>
>
> +   <row><entry></entry></row>
> +       <row id="v4l2-mpeg-video-horz-search-range">
> + <entry 
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE</constant>&nbsp;</entry>
> + <entry>integer</entry>
> +       </row><row><entry spanname="descr">Sets the Horizontal search 
> range for Video Macro blocks.</entry>
> +       </row>
> +
> + <row><entry></entry></row>
> +       <row id="v4l2-mpeg-video-vert-search-range">
> + <entry 
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE</constant>&nbsp;</entry>
> + <entry>integer</entry>
> +       </row><row><entry spanname="descr">Sets the Vertical search range 
> for Video Macro blocks.</entry>
> +       </row>
> +
>        <row><entry></entry></row>
>        <row>
>  <entry 
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE</constant>&nbsp;</entry>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h 
> b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index 6920b54..f2c13c3 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -430,6 +430,8 @@ struct s5p_mfc_vp8_enc_params {
> struct s5p_mfc_enc_params {
>  u16 width;
>  u16 height;
> + u32 horz_range;
> + u32 vert_range;
>
>  u16 gop_size;
>  enum v4l2_mpeg_video_multi_slice_mode slice_mode;
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c 
> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 4ff3b6c..a02e7b8 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -208,6 +208,24 @@ static struct mfc_control controls[] = {
>  .default_value = 0,
>  },
>  {
> + .id = V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE,
> + .type = V4L2_CTRL_TYPE_INTEGER,
> + .name = "horizontal search range of video macro block",
> + .minimum = 16,
> + .maximum = 128,
> + .step = 16,
> + .default_value = 32,
> + },
> + {
> + .id = V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE,
> + .type = V4L2_CTRL_TYPE_INTEGER,
> + .name = "vertical search range of video macro block",
> + .minimum = 16,
> + .maximum = 128,
> + .step = 16,
> + .default_value = 32,
> + },
> + {
>  .id = V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE,
>  .type = V4L2_CTRL_TYPE_INTEGER,
>  .minimum = 0,
> @@ -1377,6 +1395,12 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl 
> *ctrl)
>  case V4L2_CID_MPEG_VIDEO_VBV_SIZE:
>  p->vbv_size = ctrl->val;
>  break;
> + case V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE:
> + p->horz_range = ctrl->val;
> + break;
> + case V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE:
> + p->vert_range = ctrl->val;
> + break;
>  case V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE:
>  p->codec.h264.cpb_size = ctrl->val;
>  break;
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c 
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index 461358c..47e1807 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -727,14 +727,10 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx 
> *ctx)
>  WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
>
>  /* setting for MV range [16, 256] */
> - reg = 0;
> - reg &= ~(0x3FFF);
> - reg = 256;
> + reg = (p->horz_range & 0x3fff); /* conditional check in app */
>  WRITEL(reg, S5P_FIMV_E_MV_HOR_RANGE_V6);
>
> - reg = 0;
> - reg &= ~(0x3FFF);
> - reg = 256;
> + reg = (p->vert_range & 0x3fff); /* conditional check in app */
>  WRITEL(reg, S5P_FIMV_E_MV_VER_RANGE_V6);
>
>  WRITEL(0x0, S5P_FIMV_E_FRAME_INSERTION_V6);
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c 
> b/drivers/media/v4l2-core/v4l2-ctrls.c
> index fb46790..7cf23d5 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -735,6 +735,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>  case V4L2_CID_MPEG_VIDEO_DEC_PTS: return "Video Decoder PTS";
>  case V4L2_CID_MPEG_VIDEO_DEC_FRAME: return "Video Decoder Frame Count";
>  case V4L2_CID_MPEG_VIDEO_VBV_DELAY: return "Initial Delay for VBV 
> Control";
> + case V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE: return "hor search range of 
> video MB";
> + case V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE: return "vert search range of 
> video MB";
>  case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER: return "Repeat Sequence 
> Header";
>
>  /* VPX controls */
> @@ -905,6 +907,18 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum 
> v4l2_ctrl_type *type,
>  *min = 0;
>  *max = *step = 1;
>  break;
> + case V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE:
> + *type = V4L2_CTRL_TYPE_INTEGER;
> + *min = 16;
> + *max = 128;
> + *step = 16;
> + break;
> + case V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE:
> + *type = V4L2_CTRL_TYPE_INTEGER;
> + *min = 16;
> + *max = 128;
> + *step = 16;
> + break;
>  case V4L2_CID_PAN_RESET:
>  case V4L2_CID_TILT_RESET:
>  case V4L2_CID_FLASH_STROBE:
> diff --git a/include/uapi/linux/v4l2-controls.h 
> b/include/uapi/linux/v4l2-controls.h
> index 1666aab..bcce536 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -372,6 +372,8 @@ enum v4l2_mpeg_video_multi_slice_mode {
> #define V4L2_CID_MPEG_VIDEO_DEC_FRAME (V4L2_CID_MPEG_BASE+224)
> #define V4L2_CID_MPEG_VIDEO_VBV_DELAY (V4L2_CID_MPEG_BASE+225)
> #define V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER (V4L2_CID_MPEG_BASE+226)
> +#define V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE (V4L2_CID_MPEG_BASE+227)
> +#define V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE (V4L2_CID_MPEG_BASE+228)
>
> #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP (V4L2_CID_MPEG_BASE+300)
> #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP (V4L2_CID_MPEG_BASE+301)
> -- 
> 1.7.9.5
> 
