Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935420AbaH0RRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:17:55 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:42142 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935024AbaH0RRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:17:53 -0400
X-AuditID: cbfec373-b7f9d6d00000479f-8d-53fe12c01544
Date: Wed, 27 Aug 2014 14:17:46 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-doc <linux-doc@vger.kernel.org>
Subject: Re: randconfig build error with next-20140826,
 in Documentation/video4linux
Message-id: <20140827141746.1ea8c11c.m.chehab@samsung.com>
In-reply-to: <53FDECD5.7000804@infradead.org>
References: <CA+r1Zhh5n3p8Zg+Uvqvjeb3S859iejXkqStnnOuezTTm9UCT8g@mail.gmail.com>
 <20140827105838.GA6522@sudip-PC> <53FDECD5.7000804@infradead.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/hEN0DQv+CDfacYrXof7Wc2WJh2xIW
	i8u75rBZ9GzYympxcGEbo8XbO9NZLLbuvcpuceD0FGYHDo/GGzfYPHbOusvusXmFlsfnTXIB
	LFFcNimpOZllqUX6dglcGTO3bmcsuKJSMe3tLNYGxsUKXYycHBICJhKXpjSwQdhiEhfurQey
	uTiEBJYwSkxaOw/KaWaS2LpvG2MXIwcHi4CqxInTqiANbAJGEq8aW1hBbBEBDYnfV66wgtQz
	C6xhkpjR08cOkhAWCJO49fUaWBGvgJXEvbeHweKcAroSk+avhFowjVHi0ZZr7BBnOEv8nDmJ
	EaJBUOLH5HssIDazgJbE5m1NrBC2vMTmNW+ZJzAKzEJSNgtJ2SwkZQsYmVcxipYWJxcUJ6Xn
	GukVJ+YWl+al6yXn525ihIR58Q7GFxusDjEKcDAq8fB6LP4TLMSaWFZcmXuIUYKDWUmEt+zA
	32Ah3pTEyqrUovz4otKc1OJDjEwcnFINjIFdIdcm7ao6w5LHxCd8v8hD+ULi3nkiWSt/H9vB
	VsjDZXc/acm7h9u2v+f0ZrWaJdTB2Sc64U4b1wKFqGa165yzFmfZ8HY9Tv5ht8Ky8Mhc3d3L
	9k0X/bPzvI/rs5KW6/3nv1tceNeisVPp/OxbexV2H3ZYNZetij0k93b7rtrTp16LSxwxDVRi
	Kc5INNRiLipOBACOVCnJUQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 27 Aug 2014 07:36:05 -0700
Randy Dunlap <rdunlap@infradead.org> escreveu:

> On 08/27/14 03:58, Sudip Mukherjee wrote:
> > On Tue, Aug 26, 2014 at 09:50:43AM -0700, Jim Davis wrote:
> >> Building with the attached random configuration file,
> >>
> >> ERROR: "vb2_ops_wait_finish"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_ops_wait_prepare"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_event_unsubscribe"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_ctrl_subscribe_event"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_ctrl_log_status"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_ioctl_streamoff"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_ioctl_streamon"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_ioctl_create_bufs"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_ioctl_dqbuf"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_ioctl_expbuf"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_ioctl_qbuf"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_ioctl_querybuf"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_ioctl_reqbufs"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_fop_release"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_fh_open" [Documentation/video4linux/v4l2-pci-skeleton.ko]
> >> undefined!
> >> ERROR: "vb2_fop_mmap" [Documentation/video4linux/v4l2-pci-skeleton.ko]
> >> undefined!
> >> ERROR: "video_ioctl2" [Documentation/video4linux/v4l2-pci-skeleton.ko]
> >> undefined!
> >> ERROR: "vb2_fop_poll" [Documentation/video4linux/v4l2-pci-skeleton.ko]
> >> undefined!
> >> ERROR: "vb2_fop_read" [Documentation/video4linux/v4l2-pci-skeleton.ko]
> >> undefined!
> >> ERROR: "vb2_buffer_done"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "__video_register_device"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "video_device_release_empty"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_dma_contig_init_ctx"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_queue_init"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_dma_contig_memops"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_ctrl_new_std"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_ctrl_handler_init_class"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_device_register"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_match_dv_timings"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_find_dv_timings_cap"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_valid_dv_timings"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_enum_dv_timings_cap"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "video_devdata"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_device_unregister"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "vb2_dma_contig_cleanup_ctx"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "v4l2_ctrl_handler_free"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> ERROR: "video_unregister_device"
> >> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
> >> make[1]: *** [__modpost] Error 1
> >> make: *** [modules] Error 2
> >>
> >> Similar to a build error from January 7th:
> >> https://lists.01.org/pipermail/kbuild-all/2014-January/002566.html
> > 
> > Hi,
> > I tried to build next-20140826 with your given config file . But for me everything was fine.
> > And I was just wondering why the skeleton code in the Documentation is building ?
> 
> It builds if the Kconfig symbol BUILD_DOCSRC is enabled.
> Building of this module was just added to linux-next.

It makes sense to add a depends on BUILD_DOCSRC, PCI and MEDIA_V4L2
inside the docs Makefile, instead of moving the Kconfig to 
drivers/media, IMHO.

Regards,
Mauro
