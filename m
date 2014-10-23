Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaJWEJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:09:17 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:46740 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbaJWEJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:09:04 -0400
MIME-Version: 1.0
In-Reply-To: <20141022081429.GA21955@aepfle.de>
References: <1397199383-30186-1-git-send-email-olaf@aepfle.de>
	<20140612052351.GA25374@aepfle.de>
	<20140826101639.GA12400@aepfle.de>
	<20141022081429.GA21955@aepfle.de>
Date: Thu, 23 Oct 2014 14:09:02 +1000
Message-ID: <CAPM=9tw2hBen=vuAY176za_D5ROeK5q0KHO8Uu=Tz76kkhJbpA@mail.gmail.com>
Subject: Re: [PATCH] drm/cirrus: bind also to qemu-xen-traditional
From: Dave Airlie <airlied@gmail.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Dave Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No idea why I kept missing this, I've applied it to -fixes now.

Dave.

On 22 October 2014 18:14, Olaf Hering <olaf@aepfle.de> wrote:
> Ping?
>
> On Tue, Aug 26, Olaf Hering wrote:
>
>> Ping?
>>
>> On Thu, Jun 12, Olaf Hering wrote:
>>
>> > Ping?
>> >
>> > On Fri, Apr 11, Olaf Hering wrote:
>> >
>> > > qemu as used by xend/xm toolstack uses a different subvendor id.
>> > > Bind the drm driver also to this emulated card.
>> > >
>> > > Signed-off-by: Olaf Hering <olaf@aepfle.de>
>> > > ---
>> > >  drivers/gpu/drm/cirrus/cirrus_drv.c | 2 ++
>> > >  1 file changed, 2 insertions(+)
>> > >
>> > > diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.c b/drivers/gpu/drm/cirrus/cirrus_drv.c
>> > > index 953fc8a..8555548 100644
>> > > --- a/drivers/gpu/drm/cirrus/cirrus_drv.c
>> > > +++ b/drivers/gpu/drm/cirrus/cirrus_drv.c
>> > > @@ -31,6 +31,8 @@ static struct drm_driver driver;
>> > >  static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
>> > >   { PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, 0x1af4, 0x1100, 0,
>> > >     0, 0 },
>> > > + { PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, PCI_VENDOR_ID_XEN,
>> > > +   0x0001, 0, 0, 0 },
>> > >   {0,}
>> > >  };
>> > >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
