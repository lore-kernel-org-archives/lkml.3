Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab3EPKfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:35:45 -0400
Received: from abc.logicbricks.com ([89.201.165.132]:61457 "EHLO
	abc.logicbricks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3EPKfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:35:43 -0400
Content-Class: urn:content-classes:message
Subject: RE: fb driver for logiCVC
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Date: Thu, 16 May 2013 12:35:38 +0200
Message-ID: <ABCSCiTtUDvkm6WeI5J00000073@abc.logicbricks.com>
In-Reply-To: <20130515184112.251bb949@neptune.home>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: fb driver for logiCVC
thread-index: Ac5RixGTCs3yvSDiQMqCfL/AA883WAAkr3eg
References: <9D79B9A9194389468A922F618415D0A401229E7E@abc.xylon.local> <20130515184112.251bb949@neptune.home>
From: "Davor Joja" <Davor.Joja@logicbricks.com>
To: =?utf-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4GAZnxt021347

Hello Bruno,

Thank you for the answer!

I did not send it before to linux-fbdev since I thought that it is more likely to get answer at linux-kernel list.
Will do that from now.

Unfortunately, I have this driver on mentioned git only for few weeks, so there is no usable history.
Since this is new driver, tested and functional (on kernel 3.8), without git history as stated above, do you have idea how to break it to smaller pieces? I can only think off as one big patch against 3.8.x version.
That could be accepted for new driver?

You are right about git, it is not organized in standard way.
It is created for our customers to easily get latest drivers for Xylon IP cores because they already know what they need and in which folder to search. Maybe this was not good idea to send that git link for review. Will stitch to patches in the future, even for new drivers.

Regards,
Davor


-----Original Message-----
From: Bruno PrÃ©mont [mailto:bonbons@linux-vserver.org] 
Sent: Wednesday, May 15, 2013 6:41 PM
To: Davor Joja
Cc: linux-kernel@vger.kernel.org; linux-fbdev@vger.kernel.org
Subject: Re: fb driver for logiCVC

Hello Davor,

On Tue, 14 May 2013 "Davor Joja" wrote:
> Can I get suggestion how to send driver to this list which consists of 
> several files and folders, as one (big) patch or as described in 
> "how-to" as link to some ftp or git?
> My previous mail has not been replied, because of link to driver or 
> other issue (tested on kernel 3.8)?

You should also send it to linux-fbdev (CCed) so interested people have a better chance of seeing it (and quoting previous mail below).

If you have a git tree with history it might be nice. Otherwise it's easier to review if you can split the big-patch into multiple incremental parts adding some functionality each (that incremental nature would also be expected from a git tree).

Your tree at https://github.com/logicbricks/linux_kernel looks weird, you seem to have imported just the subfolders of kernel tree you worked on instead of cloning e.g. v3.8 release and applying your driver on top of it. This way it's not possible to merge your tree and it's rather hard to find out what belongs to your driver or not.

Bruno

On Wed, 08 May 2013 "Davor Joja" wrote:
> I am sending link to frame buffer driver for Xylon "logiCVC" FPGA IP 
> core, so I would kindly ask for driver review.
> logiCVC is Configurable Video Controller developed for Xilinx FPGA 
> devices.
> logiCVC device together with xylonfb driver is widely used in Xilinx 
> Targeted Referent Designs on Zynq SoC platforms (ZC702, ZC706, ZED, 
> TED, Xilinx customers and Xilinx university program) and on custom 
> projects from Xylon and Xylon customers.
> 
> Driver implements platform and open firmware registration types.
> It has built in interface with V4L2 ADV7511 HDMI transmitter driver 
> for handling EDID and miscellaneous clock generator SI570 driver.
> I would seek an advice for above mentioned and other issues which will 
> get to surface in review.
> 
> For now fb driver runs on 3.8 kernel (ARM architecture), and it was 
> tested in all its configurations with:
> - Xylon test application
> - fbdev - Frame buffer device test application
> - DirectFB,
> - QT
> - Ubuntu 10.04 (16bpp and 32bpp color depth) Driver build was tested 
> by Open Source Technology Center.
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
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
