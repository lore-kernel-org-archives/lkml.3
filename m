Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab3ILSYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:24:32 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:57462 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3ILSY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:24:27 -0400
X-AuditID: cbfec372-b7fe76d000003347-4f-523206d9c668
Date: Thu, 12 Sep 2013 15:24:20 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH -next] staging/media: fix msi3101 build errors
Message-id: <20130912152420.73cd6a66@samsung.com>
In-reply-to: <5232018F.3000009@iki.fi>
References: <20130912143402.73f77e0cef1e19576b77a6b5@canb.auug.org.au>
 <5231FCFC.40505@infradead.org> <5232018F.3000009@iki.fi>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/hEN2bbEZBBuc6TCy+N79ns7i8aw6b
	Rc+GrawWBxe2MVq8vTOdxWLr3qvsDmwejTdusHkc/rqQxWPzCi2Pz5vkAliiuGxSUnMyy1KL
	9O0SuDI27ehjLZgtXjFr0XnWBsZ/wl2MHBwSAiYSn476dDFyApliEhfurWfrYuTiEBJYwihx
	9e9mVginm0li+qSFrCBVLAKqEq+WdzGB2GwCRhKvGlvA4iICShILNuwEizML7GKUuNguDGIL
	CzhJvL7Qzgxi8woYSjy52soGYnMKqElMOfKEEWJBI6NEz5u5jBAXOUlsneoLUS8o8WPyPRaI
	mVoSm7c1sULY8hKb17xlnsAoMAtJ2SwkZbOQlC1gZF7FKFpanFxQnJSea6hXnJhbXJqXrpec
	n7uJERLORTsYn22wOsQowMGoxMPrcMkwSIg1say4MvcQowQHs5IIr8x/oBBvSmJlVWpRfnxR
	aU5q8SFGJg5OqQbGlR/CG612L/384eii7OsXyhwbz2jXq6brnTr17PHZ2/enhRgo83T9yZoS
	2fq6M3h+u5HQWYbNT0u2X78uZei3zOxYzNOAoswdb2x05I5cUdfj9xR9NdtD423GN2Pe5U8u
	27B+SL4dfa133vfIh5yCMsuSvZdIX6h/Vv1Ol2cl40Rv5c3R/U7uSizFGYmGWsxFxYkAylWo
	RUUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 12 Sep 2013 21:01:51 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Hello Randy,
> It is already fixed, waiting for Mauro's processing.
> https://patchwork.kernel.org/patch/2856771/

Ok. I'll handle the patches after the release of -rc1.

Regards,
Mauro

> 
> regards
> Antti
> 
> On 09/12/2013 08:42 PM, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@infradead.org>
> >
> > Fix build error when VIDEOBUF2_CORE=m and USB_MSI3101=y.
> >
> > drivers/built-in.o: In function `msi3101_buf_queue':
> > sdr-msi3101.c:(.text+0x1298d6): undefined reference to `vb2_buffer_done'
> > drivers/built-in.o: In function `msi3101_cleanup_queued_bufs':
> > sdr-msi3101.c:(.text+0x1299c7): undefined reference to `vb2_buffer_done'
> > drivers/built-in.o: In function `msi3101_isoc_handler':
> > sdr-msi3101.c:(.text+0x12a08d): undefined reference to `vb2_plane_vaddr'
> > sdr-msi3101.c:(.text+0x12a0b9): undefined reference to `vb2_buffer_done'
> > drivers/built-in.o: In function `msi3101_probe':
> > sdr-msi3101.c:(.text+0x12a1c5): undefined reference to `vb2_vmalloc_memops'
> > sdr-msi3101.c:(.text+0x12a1d7): undefined reference to `vb2_queue_init'
> > drivers/built-in.o:(.rodata+0x34cf0): undefined reference to `vb2_ioctl_reqbufs'
> > drivers/built-in.o:(.rodata+0x34cf4): undefined reference to `vb2_ioctl_querybuf'
> > drivers/built-in.o:(.rodata+0x34cf8): undefined reference to `vb2_ioctl_qbuf'
> > drivers/built-in.o:(.rodata+0x34d00): undefined reference to `vb2_ioctl_dqbuf'
> > drivers/built-in.o:(.rodata+0x34d04): undefined reference to `vb2_ioctl_create_bufs'
> > drivers/built-in.o:(.rodata+0x34d08): undefined reference to `vb2_ioctl_prepare_buf'
> > drivers/built-in.o:(.rodata+0x34d18): undefined reference to `vb2_ioctl_streamon'
> > drivers/built-in.o:(.rodata+0x34d1c): undefined reference to `vb2_ioctl_streamoff'
> > drivers/built-in.o:(.rodata+0x35580): undefined reference to `vb2_fop_read'
> > drivers/built-in.o:(.rodata+0x35588): undefined reference to `vb2_fop_poll'
> > drivers/built-in.o:(.rodata+0x35598): undefined reference to `vb2_fop_mmap'
> > drivers/built-in.o:(.rodata+0x355a0): undefined reference to `vb2_fop_release'
> > drivers/built-in.o:(.data+0x23b40): undefined reference to `vb2_ops_wait_prepare'
> > drivers/built-in.o:(.data+0x23b44): undefined reference to `vb2_ops_wait_finish'
> >
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Antti Palosaari <crope@iki.fi>
> > ---
> >   drivers/staging/media/msi3101/Kconfig |    2 ++
> >   1 file changed, 2 insertions(+)
> >
> > --- linux-next-20130912.orig/drivers/staging/media/msi3101/Kconfig
> > +++ linux-next-20130912/drivers/staging/media/msi3101/Kconfig
> > @@ -1,3 +1,5 @@
> >   config USB_MSI3101
> >   	tristate "Mirics MSi3101 SDR Dongle"
> >   	depends on USB && VIDEO_DEV && VIDEO_V4L2
> > +	select VIDEOBUF2_CORE
> > +	select VIDEOBUF2_VMALLOC
> >
> 
> 


-- 

Cheers,
Mauro
