Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab3JDPBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:01:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35415 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3JDPBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:01:51 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-c5-524ed85b8cbf
From: Inki Dae <inki.dae@samsung.com>
To: "'Sean Paul'" <seanpaul@chromium.org>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'DRI mailing list'" <dri-devel@lists.freedesktop.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        "'Dave Airlie'" <airlied@linux.ie>
References: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
 <1380839303-4834-1-git-send-email-seanpaul@chromium.org>
 <1380839303-4834-5-git-send-email-seanpaul@chromium.org>
 <CAAQKjZNKLtqKK8eoKukHwARBMBYdWfHwxdWS-aU=YjYW+KU+Gg@mail.gmail.com>
 <CAOw6vbKWjBL8jZ9iQ_Nk7-SmoTcTZ8TSMiwjOc2qT=HaJYFjAw@mail.gmail.com>
 <CAAQKjZMfP_Cgo5hPPTiwKa_+Ph+GUt2Fbdtipd5V=CQEDy3eSQ@mail.gmail.com>
 <CAOw6vbL_W-8S+htX9KB2ABbtr9+JhfxHuL2ikJG7CrqEkeo9NA@mail.gmail.com>
In-reply-to: <CAOw6vbL_W-8S+htX9KB2ABbtr9+JhfxHuL2ikJG7CrqEkeo9NA@mail.gmail.com>
Subject: RE: [PATCH v2 4/5] drm/exynos: Initialize ptn3460 if present
Date: Sat, 05 Oct 2013 00:01:45 +0900
Message-id: <03d801cec112$a477f4a0$ed67dde0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7BDIJK7aoKQA+hTku+P8hkC/MO4gAA9zVA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkUDf6hl+QwcZ/Rha9504yWcw/co7V
	4srX92wWvQuusllsenyN1WJh2xIWi8u75rBZzDi/j8ni7oazjA6cHrMbLrJ4bP/2gNXjfvdx
	Jo/NS+o9+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK+PivGXsBVvNKw5fm8bewNiv1cXIySEh
	YCLx9+YfJghbTOLCvfVsXYxcHEICSxklnq69zgJTdOlmHxNEYjqjxL+b/6Gc34wSX+ddZQOp
	YhNQlZi44j6YLSKgLnHt73awbmaBZUwSDQtEIRquM0v8bF3JDJLgFAiW6Pn7CswWFnCV+DHr
	PtgdLECDuh8uALN5BWwlfjUvZYSwBSV+TL4HNVRLYv3O40wQtrzE5jVvgeZwAJ2qLvHory7E
	DUYS1+fAlItI7HvxjhHkBgmBn+wS/++cYIfYJSDxbfIhFoheWYlNB5ghPpaUOLjiBssERolZ
	SDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjMLpP/3s2YQfjvQPW
	hxiTgdZPZJYSTc4HJoe8knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otK
	c1KLDzEycXBKNTAuOTlj7fmjyYov8rdcLl77knlxbzMf91/G5W5G/kta734MrfmndHvhrftC
	IokaMWlrVh0Q32FvGXHzQQpfv8bMRV+a+bea3LY+XNTydJNzwqUFLvrlFjvlk/PnZr6OrLti
	Pv2O7LVTT5vWNewTO/l2RdGrrvppTF9/qMuHLXZV2HNMcWHGkedNSizFGYmGWsxFxYkAmijT
	QgQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jQd3oG35BBktma1r0njvJZDH/yDlW
	iytf37NZ9C64ymax6fE1VouFbUtYLC7vmsNmMeP8PiaLuxvOMjpwesxuuMjisf3bA1aP+93H
	mTw2L6n36NuyitHj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ
	F+ctYy/Yal5x+No09gbGfq0uRk4OCQETiUs3+5ggbDGJC/fWs3UxcnEICUxnlPh38z8ThPOb
	UeLrvKtsIFVsAqoSE1fcB7NFBNQlrv3dzgJiMwssY5JoWCAK0XCdWeJn60pmkASnQLBEz99X
	YLawgKvEj1n3wdaxAA3qfrgAzOYVsJX41byUEcIWlPgx+R7UUC2J9TuPM0HY8hKb17wFmsMB
	dKq6xKO/uhA3GElcnwNTLiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQ
	rzgxt7g0L10vOT93EyM4dTyT2sG4ssHiEKMAB6MSD6/FGb8gIdbEsuLK3EOMEhzMSiK8xycB
	hXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmNbySuINjU3MjCyNzA0tjIzNSRNWEuc90God
	KCSQnliSmp2aWpBaBLOFiYNTqoHR17PiUlbNF7UHcnP47weXq/uk3//awZP57uPxUNNTF+1D
	XjT3WIZPvnc/80HXPs9nwR6Hp/rE+3vZba88stVtN0ND2Zy6wBPMTCs6my8oNn3jLCqft2Wy
	js/fiJbp1Yu9C045b+MqkeoOe5fEe2KVN+uPnPCH4azczhMuTe3y4djYonKcs02JpTgj0VCL
	uag4EQC4wA6fYQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sean Paul [mailto:seanpaul@chromium.org]
> Sent: Friday, October 04, 2013 11:17 PM
> To: Inki Dae
> Cc: Kukjin Kim; DRI mailing list; linux-samsung-soc@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; linux-
> doc@vger.kernel.org; devicetree@vger.kernel.org; Dave Airlie
> Subject: Re: [PATCH v2 4/5] drm/exynos: Initialize ptn3460 if present
> 
> On Fri, Oct 4, 2013 at 12:18 AM, Inki Dae <inki.dae@samsung.com> wrote:
> > 2013/10/4 Sean Paul <seanpaul@chromium.org>:
> >> On Thu, Oct 3, 2013 at 10:29 PM, Inki Dae <inki.dae@samsung.com> wrote:
> >>> 2013/10/4 Sean Paul <seanpaul@chromium.org>:
> >>>> This patch adds code to look for the ptn3460 in the device tree file
> on
> >>>> exynos initialization. If ptn node is found, the driver will
> initialize
> >>>> the ptn3460 driver and skip creating a DP connector (since the bridge
> >>>> driver will register its own connector).
> >>>>
> >>>> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> >>>> ---
> >>>>
> >>>> v2:
> >>>>         - Changed include from of_i2c.h to i2c.h
> >>>>         - Changed of_find_by_name to of_find_compatible
> >>>>
> >>>>  drivers/gpu/drm/exynos/exynos_drm_core.c | 44
> +++++++++++++++++++++++++++++++-
> >>>>  1 file changed, 43 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_core.c
> b/drivers/gpu/drm/exynos/exynos_drm_core.c
> >>>> index 1bef6dc..08ca4f9 100644
> >>>> --- a/drivers/gpu/drm/exynos/exynos_drm_core.c
> >>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_core.c
> >>>> @@ -12,7 +12,9 @@
> >>>>   * option) any later version.
> >>>>   */
> >>>>
> >>>> +#include <linux/i2c.h>
> >>>>  #include <drm/drmP.h>
> >>>> +#include <drm/bridge/ptn3460.h>
> >>>>  #include "exynos_drm_drv.h"
> >>>>  #include "exynos_drm_encoder.h"
> >>>>  #include "exynos_drm_connector.h"
> >>>> @@ -20,6 +22,40 @@
> >>>>
> >>>>  static LIST_HEAD(exynos_drm_subdrv_list);
> >>>>
> >>>> +struct bridge_init {
> >>>> +       struct i2c_client *client;
> >>>> +       struct device_node *node;
> >>>> +};
> >>>> +
> >>>> +static bool find_bridge(const char *compat, struct bridge_init
> *bridge)
> >>>> +{
> >>>> +       bridge->client = NULL;
> >>>> +       bridge->node = of_find_compatible_node(NULL, NULL, compat);
> >>>
> >>> Then, shouldn't the lvds-bridge driver be implemented as i2c driver so
> >>> that such tricky isn't needed? Is there any reason you use such tricky
> >>> codes?
> >>>
> >>
> >> This is what I was explaining earlier today. If the bridge driver is
> >> just an i2c driver, it won't get a pointer to drm_device, and can't
> >> register itself as a drm_bridge or drm_connector. To solve this, you
> >> need the ptn3460_init callback.
> >>
> >
> > No, I think you can use sub driver. how about registering to exynos
> > drm core that driver using exynos_drm_subdrv_register function after
> > probed? Is there something I am missing?
> >
> 
> The ptn driver isn't exynos-specific, so I don't think making it an
> exynos_drm_subdrv is appropriate.
> 

I _really know_ that the ptn driver isn't exynos-specific. I mean that you
can use exynos_drm_subdrv somehow. ie. you can add a new bridge module
specific to exynos, and this module can register its own sub driver at end
of probe. Why do you try to use such tricky codes?

Thanks,
Inki Dae

> Sean
> 
> >
> >> If it's an i2c driver with the ptn3460_init callback, where it parses
> >> the dt in probe, then you have a race between the ptn probe and the
> >> ptn init/drm hooks. ie: it's possible drm will initialize and call
> >> disable/post_disable/pre_enable/enable before things have been probed.
> >
> > And also, exynos drm core will call a probe callback of the sub driver
> > after _drm is initialized_. Is there something I am missing?
> >
> >> To solve this, you need to use some global state and/or locking.
> >>
> >> So, to summarize. We can have this of_find_compatible with a init
> >> callback, or we can have an i2c driver + global state/locking + init
> >> callback. I chose the former, since it seemed easier.
> >>
> >> If you have a better way to achieve this, I'm definitely interested,
> >> but I saw this as the lesser of two evils.
> >>
> >> Sean
> >>
> >>> I think you need to implement the lvds-bridge driver as i2c driver,
> >>> and then consider how to take care of this. I mean let's find a better
> >>> way how we could take care of the i2c based driver in exynos drm
> >>> framework or driver. In all cases, such tricky codes are not good.
> >>>
> >>>> +       if (!bridge->node)
> >>>> +               return false;
> >>>> +
> >>>> +       bridge->client = of_find_i2c_device_by_node(bridge->node);
> >>>> +       if (!bridge->client)
> >>>> +               return false;
> >>>> +
> >>>> +       return true;
> >>>> +}
> >>>> +
> >>>> +/* returns the number of bridges attached */
> >>>> +static int exynos_drm_attach_lcd_bridge(struct drm_device *dev,
> >>>> +               struct drm_encoder *encoder)
> >>>> +{
> >>>> +       struct bridge_init bridge;
> >>>> +       int ret;
> >>>> +
> >>>> +       if (find_bridge("nxp,ptn3460", &bridge)) {
> >>>> +               ret = ptn3460_init(dev, encoder, bridge.client,
> bridge.node);
> >>>> +               if (!ret)
> >>>> +                       return 1;
> >>>> +       }
> >>>> +       return 0;
> >>>> +}
> >>>> +
> >>>>  static int exynos_drm_create_enc_conn(struct drm_device *dev,
> >>>>                                         struct exynos_drm_subdrv
*subdrv)
> >>>>  {
> >>>> @@ -36,6 +72,13 @@ static int exynos_drm_create_enc_conn(struct
> drm_device *dev,
> >>>>                 DRM_ERROR("failed to create encoder\n");
> >>>>                 return -EFAULT;
> >>>>         }
> >>>> +       subdrv->encoder = encoder;
> >>>> +
> >>>> +       if (subdrv->manager->display_ops->type ==
> EXYNOS_DISPLAY_TYPE_LCD) {
> >>>> +               ret = exynos_drm_attach_lcd_bridge(dev, encoder);
> >>>> +               if (ret)
> >>>> +                       return 0;
> >>>> +       }
> >>>>
> >>>>         /*
> >>>>          * create and initialize a connector for this sub driver and
> >>>> @@ -48,7 +91,6 @@ static int exynos_drm_create_enc_conn(struct
> drm_device *dev,
> >>>>                 goto err_destroy_encoder;
> >>>>         }
> >>>>
> >>>> -       subdrv->encoder = encoder;
> >>>>         subdrv->connector = connector;
> >>>>
> >>>>         return 0;
> >>>> --
> >>>> 1.8.4
> >>>>
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-
> samsung-soc" in
> >>>> the body of a message to majordomo@vger.kernel.org
> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-
> samsung-soc" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html

