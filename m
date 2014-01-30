Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaA3PW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:22:27 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58273 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaA3PWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:22:23 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-3c-52ea6e2b11e9
From: Kamil Debski <k.debski@samsung.com>
To: "'Hans Verkuil'" <hverkuil@xs4all.nl>,
        "'Amit Grover'" <amit.grover@samsung.com>
Cc: linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kyungmin.park@samsung.com, prabhakar.csengg@gmail.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, hans.verkuil@cisco.com,
        swaminath.p@samsung.com, jtp.park@samsung.com, Rrob@landley.net,
        andrew.smirnov@gmail.com, anatol.pomozov@gmail.com,
        jmccrohan@gmail.com, joe@perches.com, awalls@md.metrocast.net,
        arun.kk@samsung.com, austin.lobo@samsung.com
References: <52E0ED10.2020901@samsung.com>
 <1391060563-27015-1-git-send-email-amit.grover@samsung.com>
 <1391060563-27015-2-git-send-email-amit.grover@samsung.com>
 <52EA00E5.10303@xs4all.nl>
In-reply-to: <52EA00E5.10303@xs4all.nl>
Subject: RE: [PATCH v2 1/2] drivers/media: v4l2: Add settings for Horizontal
 and Vertical MV Search Range
Date: Thu, 30 Jan 2014 16:22:18 +0100
Message-id: <051c01cf1dcf$1132ee60$3398cb20$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8djh+d2+MCYldrQZmDwL3yt7dZVgAPJc1A
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t/xa7o6ea+CDNrvMFo86/vEavGyt9Ci
	ucPW4uOp26wW8z/dZLF4055kseTnLiaLU5OfMVn0P1rPaDH7/mMWiyNrrzJZnG16w26x6fE1
	VouFbUtYLC7vmsNm0bNhK9Cc+yuYLZ6+es5mcfhNO6tFW9dURgcRjym/N7J67Jx1l93j1eqZ
	rB6bl9R7zLqwmd3jy6przB59W1YxenzeJOdx6utn9gDOKC6blNSczLLUIn27BK6M7w2X2Quu
	6VZs3vGdsYHxhEoXIyeHhICJxINvs9khbDGJC/fWs3UxcnEICSxllLjx/DELhNPAJHGmeydr
	FyMHB5uApsSqex4gDSICARI/Tp5jBqlhFnjFLHHnfx8jRMNhRonZxxYzg1RxCqhLXG++xghi
	CwtkS7y8ux/MZhFQlZj7qxmshlfAQWLfjwUsELagxI/J98BsZgEtifU7jzNB2PISm9e8ZQY5
	QgJo5qO/uhBHGElM6LvADFEiInG34TnrBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpamlxQnJSe
	a6hXnJhbXJqXrpecn7uJERLRX3YwLj5mdYhRgINRiYf3Y8arICHWxLLiytxDjBIczEoivIUp
	QCHelMTKqtSi/Pii0pzU4kOMTBycUg2MIevyBdsT7s8oeKJeeKG+o76oVnRfxh/V+ssJ3Owr
	ow7ovxU2mSTtWFjzMUv6SeFi15L1HdNM8uNSf+898NWp797iOcXxhTIXr0tvc5EWkOhb9sE5
	0FzDyjBwWQlD1bXoY6sSTJY8e3RF/l7Ym2mzWgMKv3M2PPFwuV1gxhKqkP63SmdFeocSS3FG
	oqEWc1FxIgCZaNyMxgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans, Amit,

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Thursday, January 30, 2014 8:36 AM
> 
> On 01/30/2014 06:42 AM, Amit Grover wrote:
> > Adding V4L2 controls for horizontal and vertical search range in
> > pixels for motion estimation module in video encoder.
> >
> > Signed-off-by: Swami Nathan <swaminath.p@samsung.com>
> > Signed-off-by: Amit Grover <amit.grover@samsung.com>
> > ---
> >  Documentation/DocBook/media/v4l/controls.xml |   20
> ++++++++++++++++++++
> >  drivers/media/v4l2-core/v4l2-ctrls.c         |   14 ++++++++++++++
> >  include/uapi/linux/v4l2-controls.h           |    2 ++
> >  3 files changed, 36 insertions(+)
> >
> > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> > b/Documentation/DocBook/media/v4l/controls.xml
> > index 7a3b49b..be04d18 100644
> > --- a/Documentation/DocBook/media/v4l/controls.xml
> > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > @@ -2258,6 +2258,26 @@ Applicable to the MPEG1, MPEG2, MPEG4
> > encoders.</entry>  VBV buffer control.</entry>
> >  	      </row>
> >
> > +		  <row><entry></entry></row>
> > +	      <row id=""v4l2-mpeg-video-hor-search-range">
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE</constant
> >&nbsp;</entry>
> > +		<entry>integer</entry>
> > +	      </row>
> > +		<row><entry spanname="descr">Horizontal search range
> defines
> > +maximum horizontal search area in pixels to search and match for the
> > +present Macroblock (MB) in the reference picture. This V4L2 control
> macro is used to set horizontal search range for motion estimation
> module in video encoder.</entry>
> > +	      </row>
> > +
> > +		 <row><entry></entry></row>
> > +	      <row id="v4l2-mpeg-video-vert-search-range">
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE</constant
> >&nbsp;</entry>
> > +		<entry>integer</entry>
> 
> These two controls sound very mfc specific as opposed to being part of
> the standard.
> If so, then they should be named V4L2_CID_MPEG_MFC51_*. 

mencoder has an option to set motion vector search radius.

>From man mencoder:
       me_range=<4-64>
              radius  of  exhaustive  or multi-hexagon motion search
(default:
              16)

So I think it could be applicable to other hardware codecs as well.

> Also, for which codecs are these controls applicable?

Isn't the choice of motion estimation algorithm (and its parameters)
codec agnostic, as long as the restrictions of the standard are honoured?

> 
> > +	      </row>
> > +		<row><entry spanname="descr">Vertical search range defines
> maximum
> > +vertical search area in pixels to search and match for the present
> > +Macroblock (MB) in the reference picture. This V4L2 control macro is
> used to set vertical search range for motion estimation module in video
> encoder.</entry>
> > +	      </row>
> > +
> >  	      <row><entry></entry></row>
> >  	      <row>
> >  		<entry
> >
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE</constant>&n
> > bsp;</entry> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> > b/drivers/media/v4l2-core/v4l2-ctrls.c
> > index fb46790..e775388 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -735,6 +735,8 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_MPEG_VIDEO_DEC_PTS:			return
"Video
> Decoder PTS";
> >  	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:			return
"Video
> Decoder Frame Count";
> >  	case V4L2_CID_MPEG_VIDEO_VBV_DELAY:			return
"Initial
> Delay for VBV Control";
> > +	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:		return
> "Horizontal MV Search Range";
> > +	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		return
> "Vertical MV Search Range";
> >  	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return
> "Repeat Sequence Header";
> >
> >  	/* VPX controls */
> > @@ -905,6 +907,18 @@ void v4l2_ctrl_fill(u32 id, const char **name,
> enum v4l2_ctrl_type *type,
> >  		*min = 0;
> >  		*max = *step = 1;
> >  		break;
> > +	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:
> > +		*type = V4L2_CTRL_TYPE_INTEGER;
> > +		*min = 16;
> > +		*max = 128;
> > +		*step = 16;
> 
> Weird range, why not use range 1-8?

If the search range is represented in pixels, then pixels should be used.
It the control is also used in other hardware, then I think it the values
should not be limited in this way here. For example mencoder accepts the
value between 4 and 64. The range and step could be limited in the
s5p_mfc_enc.c.

> 
> > +		break;
> > +	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:
> > +		*type = V4L2_CTRL_TYPE_INTEGER;
> > +		*min = 16;
> > +		*max = 128;
> > +		*step = 16;
> > +		break;
> >  	case V4L2_CID_PAN_RESET:
> >  	case V4L2_CID_TILT_RESET:
> >  	case V4L2_CID_FLASH_STROBE:
> > diff --git a/include/uapi/linux/v4l2-controls.h
> > b/include/uapi/linux/v4l2-controls.h
> > index 1666aab..80e1def 100644
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -372,6 +372,8 @@ enum v4l2_mpeg_video_multi_slice_mode {
> >  #define V4L2_CID_MPEG_VIDEO_DEC_FRAME
> 	(V4L2_CID_MPEG_BASE+224)
> >  #define V4L2_CID_MPEG_VIDEO_VBV_DELAY
> 	(V4L2_CID_MPEG_BASE+225)
> >  #define V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER
> 	(V4L2_CID_MPEG_BASE+226)
> > +#define V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE
> 	(V4L2_CID_MPEG_BASE+227)
> > +#define V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE
> 	(V4L2_CID_MPEG_BASE+228)
> >
> >  #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP
> 	(V4L2_CID_MPEG_BASE+300)
> >  #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP
> 	(V4L2_CID_MPEG_BASE+301)
> >
> 
> Regards,
> 
> 	Hans

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

