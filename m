Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbbA1VWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:22:37 -0500
Received: from mout.gmx.net ([212.227.17.21]:54029 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964965AbbA1UuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:05 -0500
Date: Wed, 28 Jan 2015 21:49:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Josh Wu <josh.wu@atmel.com>
cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: v4l2-image-sizes.h: add SVGA, XGA and UXGA
 size definitions
In-Reply-To: <54C844D2.9040905@atmel.com>
Message-ID: <Pine.LNX.4.64.1501282148370.24956@axis700.grange>
References: <1416905668-23029-1-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1411252318330.17362@axis700.grange> <547698A6.3090703@atmel.com>
 <Pine.LNX.4.64.1411272112320.5267@axis700.grange> <54C844D2.9040905@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V03:K0:cq0LU7TComh+QkRNOMfSPtsygzCfkhJb4JKEnXF8VzHxfonlSkq
 v2oISIPiLc4Hm/e/qyM6YlKNucdcudfxPhtsnv+oonFP7/zQkS2ZMcrbt3As68jTNsTBzuv
 eieNfUoCDamsc47htaegZCIE6D/6n1V3W3KdvRxlFTaetiHDPDF8QeGiFu0Vt24oU4oZDFp
 i+dnIJEpNsr90xWXtSnyw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Wed, 28 Jan 2015, Josh Wu wrote:

> Hi, Guennadi
> 
> On 11/28/2014 4:13 AM, Guennadi Liakhovetski wrote:
> > Hi Josh,
> > 
> > On Thu, 27 Nov 2014, Josh Wu wrote:
> > 
> > > Hi, Guennadi
> > > 
> > > On 11/26/2014 6:23 AM, Guennadi Liakhovetski wrote:
> > > > Hi Josh,
> > > > 
> > > > On Tue, 25 Nov 2014, Josh Wu wrote:
> > > > 
> > > > > Add SVGA, UXGA and XGA size definitions to v4l2-image-sizes.h.
> > > > > The definitions are sorted by alphabet order.
> > > > > 
> > > > > Signed-off-by: Josh Wu <josh.wu@atmel.com>
> > > > Thanks for your patches. I'm ok with these two, but the second of them
> > > > depends on the first one, and the first one wouldn't (normally) be going
> > > > via the soc-camera tree. Mauro, how would you prefer to handle this?
> > > > Should I pick up and push to you both of them or postpone #2 until the
> > > > next merge window?
> > > The first patch is already merged in the media_tree. If the soc-camera
> > > tree
> > > will be merged to the media_tree, then there should have no dependency
> > > issue.
> > > Am I understanding correct?
> > Yes, then it should be ok!
> 
> Just checking the status of this patch. I don't found this patch in media's
> tree or soc_camera's tree.
> Could you take this patch in your tree?

uhm, yes, sorry, I'll try to make sure not to miss it with my next pull 
request. Thanks for a reminder!

Regards
Guennadi

> Best Regards,
> Josh Wu
> 
> > 
> > Thanks
> > Guennadi
> > 
> > > Best Regards,
> > > Josh Wu
> > > 
> > > > Thanks
> > > > Guennadi
> > > > 
> > > > > ---
> > > > >    include/media/v4l2-image-sizes.h | 9 +++++++++
> > > > >    1 file changed, 9 insertions(+)
> > > > > 
> > > > > diff --git a/include/media/v4l2-image-sizes.h
> > > > > b/include/media/v4l2-image-sizes.h
> > > > > index 10daf92..c70c917 100644
> > > > > --- a/include/media/v4l2-image-sizes.h
> > > > > +++ b/include/media/v4l2-image-sizes.h
> > > > > @@ -25,10 +25,19 @@
> > > > >    #define QVGA_WIDTH	320
> > > > >    #define QVGA_HEIGHT	240
> > > > >    +#define SVGA_WIDTH	800
> > > > > +#define SVGA_HEIGHT	680
> > > > > +
> > > > >    #define SXGA_WIDTH	1280
> > > > >    #define SXGA_HEIGHT	1024
> > > > >      #define VGA_WIDTH	640
> > > > >    #define VGA_HEIGHT	480
> > > > >    +#define UXGA_WIDTH	1600
> > > > > +#define UXGA_HEIGHT	1200
> > > > > +
> > > > > +#define XGA_WIDTH	1024
> > > > > +#define XGA_HEIGHT	768
> > > > > +
> > > > >    #endif /* _IMAGE_SIZES_H */
> > > > > -- 
> > > > > 1.9.1
> > > > > 
> 
