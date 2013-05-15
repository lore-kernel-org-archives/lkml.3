Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab3EOQlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:41:42 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:52609 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab3EOQll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:41:41 -0400
Date: Wed, 15 May 2013 18:41:12 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Davor Joja" <Davor.Joja@logicbricks.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: Re: fb driver for logiCVC
Message-ID: <20130515184112.251bb949@neptune.home>
In-Reply-To: <9D79B9A9194389468A922F618415D0A401229E7E@abc.xylon.local>
References: <9D79B9A9194389468A922F618415D0A401229E7E@abc.xylon.local>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Davor,

On Tue, 14 May 2013 "Davor Joja" wrote:
> Can I get suggestion how to send driver to this list which consists of
> several files and folders, as one (big) patch or as described in
> "how-to" as link to some ftp or git?
> My previous mail has not been replied, because of link to driver or
> other issue (tested on kernel 3.8)?

You should also send it to linux-fbdev (CCed) so interested people have
a better chance of seeing it (and quoting previous mail below).

If you have a git tree with history it might be nice. Otherwise it's
easier to review if you can split the big-patch into multiple incremental
parts adding some functionality each (that incremental nature would also
be expected from a git tree).

Your tree at https://github.com/logicbricks/linux_kernel looks weird,
you seem to have imported just the subfolders of kernel tree you worked
on instead of cloning e.g. v3.8 release and applying your driver on top
of it. This way it's not possible to merge your tree and it's rather hard
to find out what belongs to your driver or not.

Bruno

On Wed, 08 May 2013 "Davor Joja" wrote:
> I am sending link to frame buffer driver for Xylon "logiCVC" FPGA IP
> core, so I would kindly ask for driver review.
> logiCVC is Configurable Video Controller developed for Xilinx FPGA
> devices.
> logiCVC device together with xylonfb driver is widely used in Xilinx
> Targeted Referent Designs on Zynq SoC platforms (ZC702, ZC706, ZED, TED,
> Xilinx customers and Xilinx university program) and on custom projects
> from Xylon and Xylon customers.
> 
> Driver implements platform and open firmware registration types.
> It has built in interface with V4L2 ADV7511 HDMI transmitter driver for
> handling EDID and miscellaneous clock generator SI570 driver.
> I would seek an advice for above mentioned and other issues which will
> get to surface in review.
> 
> For now fb driver runs on 3.8 kernel (ARM architecture), and it was
> tested in all its configurations with:
> - Xylon test application
> - fbdev - Frame buffer device test application
> - DirectFB,
> - QT
> - Ubuntu 10.04 (16bpp and 32bpp color depth) Driver build was tested by
> Open Source Technology Center.
> 
> Latest driver is available at
> https://github.com/logicbricks/linux_kernel.git under
> "drivers/video/xylon" and "include/linux" "Documentation (xylonfb
> devicetree parameters)"
> It is available on https://github.com/xilinx but not latest version.
> 
> I have placed on ftp.logicbricks.com logiCVC datasheet, application
> note, current xylonfb driver user manual and test applications.
> Username: xylonfb
> Password: xylonfb
