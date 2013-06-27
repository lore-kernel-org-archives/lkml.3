Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3F0RE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:04:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33408 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3F0REZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:04:25 -0400
Message-ID: <51CC707E.6030204@infradead.org>
Date: Thu, 27 Jun 2013 10:03:58 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: Re: linux-next: Tree for Jun 27 (v4l2 & usbtv)
References: <20130627192416.d37a51646a5317892298609e@canb.auug.org.au>
In-Reply-To: <20130627192416.d37a51646a5317892298609e@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/13 02:24, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130626:
> 

on i386:

CONFIG_VIDEO_USBTV=y
CONFIG_I2C=m
CONFIG_VIDEO_V4L2=m


Looks like VIDEO_USBTV should depend on VIDEO_V4L2.


drivers/built-in.o: In function `vb2_fop_mmap':
(.text+0x199b4e): undefined reference to `video_devdata'
drivers/built-in.o: In function `vb2_ioctl_streamoff':
(.text+0x19a00b): undefined reference to `video_devdata'
drivers/built-in.o: In function `vb2_ioctl_streamon':
(.text+0x19a134): undefined reference to `video_devdata'
drivers/built-in.o: In function `vb2_ioctl_expbuf':
(.text+0x19a2cb): undefined reference to `video_devdata'
drivers/built-in.o: In function `vb2_ioctl_querybuf':
(.text+0x19a3fe): undefined reference to `video_devdata'
drivers/built-in.o:(.text+0x19ad7d): more undefined references to `video_devdata' follow
drivers/built-in.o: In function `vb2_poll':
(.text+0x19bef0): undefined reference to `v4l2_event_pending'
drivers/built-in.o: In function `vb2_fop_poll':
(.text+0x19c0ce): undefined reference to `video_devdata'
drivers/built-in.o: In function `vb2_fop_release':
(.text+0x19c21c): undefined reference to `video_devdata'
drivers/built-in.o: In function `vb2_fop_release':
(.text+0x19c24a): undefined reference to `v4l2_fh_release'
drivers/built-in.o: In function `usbtv_release':
usbtv.c:(.text+0x1a9411): undefined reference to `v4l2_device_unregister'
drivers/built-in.o: In function `usbtv_querycap':
usbtv.c:(.text+0x1a942e): undefined reference to `video_devdata'
drivers/built-in.o: In function `usbtv_probe':
usbtv.c:(.text+0x1a95da): undefined reference to `v4l2_device_register'
usbtv.c:(.text+0x1a961e): undefined reference to `video_device_release_empty'
usbtv.c:(.text+0x1a9689): undefined reference to `__video_register_device'
usbtv.c:(.text+0x1a96a3): undefined reference to `v4l2_device_unregister'
drivers/built-in.o: In function `usbtv_disconnect':
usbtv.c:(.text+0x1a9937): undefined reference to `video_unregister_device'
usbtv.c:(.text+0x1a993e): undefined reference to `v4l2_device_disconnect'
drivers/built-in.o: In function `usbtv_iso_cb':
usbtv.c:(.text+0x1a9b5c): undefined reference to `v4l2_get_timestamp'
drivers/built-in.o: In function `usbtv_disconnect':
usbtv.c:(.text+0x1a9966): undefined reference to `v4l2_device_put'
drivers/built-in.o:(.data+0x22918): undefined reference to `video_ioctl2'
drivers/built-in.o:(.data+0x22924): undefined reference to `v4l2_fh_open'



-- 
~Randy
