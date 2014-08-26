Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaHZQvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:51:02 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:44054 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaHZQu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:50:58 -0400
MIME-Version: 1.0
In-Reply-To: <1397743910-18391-2-git-send-email-pefoley2@pefoley.com>
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
	<1397743910-18391-2-git-send-email-pefoley2@pefoley.com>
Date: Tue, 26 Aug 2014 20:50:56 +0400
Message-ID: <CANaxB-wEBzrr9XmAFL_3YTeiO-nsjT6Xj4Q0LnxnNMH+CnyMDg@mail.gmail.com>
Subject: Re: [PATCH 2/4] Documentation: add makefiles for more targets
From: Andrey Wagin <avagin@gmail.com>
To: Peter Foley <pefoley2@pefoley.com>
Cc: LKML <linux-kernel@vger.kernel.org>, rdunlap@infradead.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I have got following errors with this patch. I think
Documentation/video4linux should be built only if a config contains a
proper options set.

  Building modules, stage 2.
  MODPOST 73 modules
ERROR: "vb2_ops_wait_finish"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_ops_wait_prepare"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_event_unsubscribe"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_ctrl_subscribe_event"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_ctrl_log_status"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_ioctl_streamoff"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_ioctl_streamon"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_ioctl_create_bufs"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_ioctl_dqbuf"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_ioctl_expbuf"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_ioctl_qbuf"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_ioctl_querybuf"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_ioctl_reqbufs"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_fop_release"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_fh_open" [Documentation/video4linux/v4l2-pci-skeleton.ko]
undefined!
ERROR: "vb2_fop_mmap" [Documentation/video4linux/v4l2-pci-skeleton.ko]
undefined!
ERROR: "video_ioctl2" [Documentation/video4linux/v4l2-pci-skeleton.ko]
undefined!
ERROR: "vb2_fop_poll" [Documentation/video4linux/v4l2-pci-skeleton.ko]
undefined!
ERROR: "vb2_fop_read" [Documentation/video4linux/v4l2-pci-skeleton.ko]
undefined!
ERROR: "vb2_buffer_done"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "__video_register_device"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "video_device_release_empty"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_dma_contig_init_ctx"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_queue_init"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_dma_contig_memops"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_ctrl_new_std"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_ctrl_handler_init_class"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_device_register"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
  HOSTCC  arch/x86/tools/insn_sanity
ERROR: "v4l2_match_dv_timings"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_find_dv_timings_cap"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_valid_dv_timings"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_enum_dv_timings_cap"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "video_devdata"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_device_unregister"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_dma_contig_cleanup_ctx"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_ctrl_handler_free"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "video_unregister_device"
[Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....
