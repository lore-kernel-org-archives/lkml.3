Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763488Ab3IEISf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:18:35 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:8509
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756985Ab3IEISb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:18:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I103dK542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Lu Jingchang-B35083 <B35083@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHOmk6HmvW+8Uz+BkmoowcYjqk1XpmqWYUAgAAO9YCAB5LmAIAAJBEQ///5soCAAA2oYIAAPxUAgAEsl2CAAGtJgIAC7BWQ
Date: Thu, 5 Sep 2013 08:18:24 +0000
Message-ID: <B56CDBE15CE27145A4B77D2D24263E852157C4@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1376633274-17850-1-git-send-email-b35083@freescale.com>
 <20130828081742.GC11414@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520A8C7@039-SN1MPN1-003.039d.mgd.msft.net>
 <20130902045050.GE7376@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520D0D4@039-SN1MPN1-004.039d.mgd.msft.net>
 <20130902063721.GK7376@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520F101@039-SN1MPN1-004.039d.mgd.msft.net>
 <20130902111200.GP7376@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E852102A1@039-SN1MPN1-004.039d.mgd.msft.net>
 <20130903113151.GE15824@intel.com>
In-Reply-To: <20130903113151.GE15824@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.98]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r858Ifqt028692

> -----Original Message-----
> From: Vinod Koul [mailto:vinod.koul@intel.com]
> Sent: Tuesday, September 03, 2013 7:32 PM
> To: Lu Jingchang-B35083
> Cc: shawn.guo@linaro.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; devicetree@vger.kernel.org
> Subject: Re: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver support
> 
> On Tue, Sep 03, 2013 at 05:43:21AM +0000, Lu Jingchang-B35083 wrote:
> >   Do you mean the DMA_SLAVE_CONFIG device_control? Yeah, the slave
> driver could pass
> > the slave_id. But the DMA_SLAVE_CONFIG may be called more than once,
> and the eDMA
> > driver just needs to set the slave id once for any given channel, after
> that the
> > transfer is transparent to the device.
> It depends, for a channel requested, if you are only tranferring to a
> particular
> slave device then it can be confugured once.
> so
> 1. allocate channel
> 2. dmaengine_slave_config()
> 
> then you cnan do preare etc multiple times based on need.
 But if the preferred slave id configuration should be in dmaengine_slave_config,
I will send out this change in the next version patch.
Thanks!





Best Regards,
Jingchang


 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
