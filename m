Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbaJVIUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:20:54 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:31153 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbaJVIUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:20:51 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssUY5SQpelgFVa4UvA6LU+8mSbiO9suDDvTyRkUQ==
X-RZG-CLASS-ID: mo00
Date: Wed, 22 Oct 2014 10:14:29 +0200
From: Olaf Hering <olaf@aepfle.de>
To: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/cirrus: bind also to qemu-xen-traditional
Message-ID: <20141022081429.GA21955@aepfle.de>
References: <1397199383-30186-1-git-send-email-olaf@aepfle.de>
 <20140612052351.GA25374@aepfle.de>
 <20140826101639.GA12400@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140826101639.GA12400@aepfle.de>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Tue, Aug 26, Olaf Hering wrote:

> Ping?
> 
> On Thu, Jun 12, Olaf Hering wrote:
> 
> > Ping?
> > 
> > On Fri, Apr 11, Olaf Hering wrote:
> > 
> > > qemu as used by xend/xm toolstack uses a different subvendor id.
> > > Bind the drm driver also to this emulated card.
> > > 
> > > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> > > ---
> > >  drivers/gpu/drm/cirrus/cirrus_drv.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.c b/drivers/gpu/drm/cirrus/cirrus_drv.c
> > > index 953fc8a..8555548 100644
> > > --- a/drivers/gpu/drm/cirrus/cirrus_drv.c
> > > +++ b/drivers/gpu/drm/cirrus/cirrus_drv.c
> > > @@ -31,6 +31,8 @@ static struct drm_driver driver;
> > >  static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
> > >  	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, 0x1af4, 0x1100, 0,
> > >  	  0, 0 },
> > > +	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, PCI_VENDOR_ID_XEN,
> > > +	  0x0001, 0, 0, 0 },
> > >  	{0,}
> > >  };
> > >  
