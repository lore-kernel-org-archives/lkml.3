Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934929AbaH0OgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:36:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41144 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933802AbaH0OgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:36:09 -0400
Message-ID: <53FDECD5.7000804@infradead.org>
Date: Wed, 27 Aug 2014 07:36:05 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jim Davis <jim.epost@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "m.chehab" <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-doc <linux-doc@vger.kernel.org>
Subject: Re: randconfig build error with next-20140826, in Documentation/video4linux
References: <CA+r1Zhh5n3p8Zg+Uvqvjeb3S859iejXkqStnnOuezTTm9UCT8g@mail.gmail.com> <20140827105838.GA6522@sudip-PC>
In-Reply-To: <20140827105838.GA6522@sudip-PC>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/14 03:58, Sudip Mukherjee wrote:
> On Tue, Aug 26, 2014 at 09:50:43AM -0700, Jim Davis wrote:
>> Building with the attached random configuration file,
>>
>> ERROR: "vb2_ops_wait_finish"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_ops_wait_prepare"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_event_unsubscribe"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_ctrl_subscribe_event"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_ctrl_log_status"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_ioctl_streamoff"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_ioctl_streamon"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_ioctl_create_bufs"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_ioctl_dqbuf"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_ioctl_expbuf"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_ioctl_qbuf"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_ioctl_querybuf"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_ioctl_reqbufs"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_fop_release"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_fh_open" [Documentation/video4linux/v4l2-pci-skeleton.ko]
>> undefined!
>> ERROR: "vb2_fop_mmap" [Documentation/video4linux/v4l2-pci-skeleton.ko]
>> undefined!
>> ERROR: "video_ioctl2" [Documentation/video4linux/v4l2-pci-skeleton.ko]
>> undefined!
>> ERROR: "vb2_fop_poll" [Documentation/video4linux/v4l2-pci-skeleton.ko]
>> undefined!
>> ERROR: "vb2_fop_read" [Documentation/video4linux/v4l2-pci-skeleton.ko]
>> undefined!
>> ERROR: "vb2_buffer_done"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "__video_register_device"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "video_device_release_empty"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_dma_contig_init_ctx"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_queue_init"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_dma_contig_memops"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_ctrl_new_std"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_ctrl_handler_init_class"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_device_register"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_match_dv_timings"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_find_dv_timings_cap"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_valid_dv_timings"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_enum_dv_timings_cap"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "video_devdata"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_device_unregister"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "vb2_dma_contig_cleanup_ctx"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "v4l2_ctrl_handler_free"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> ERROR: "video_unregister_device"
>> [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
>>
>> Similar to a build error from January 7th:
>> https://lists.01.org/pipermail/kbuild-all/2014-January/002566.html
> 
> Hi,
> I tried to build next-20140826 with your given config file . But for me everything was fine.
> And I was just wondering why the skeleton code in the Documentation is building ?

It builds if the Kconfig symbol BUILD_DOCSRC is enabled.
Building of this module was just added to linux-next.


-- 
~Randy
