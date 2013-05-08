Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab3EHRyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:54:49 -0400
Received: from abc.logicbricks.com ([89.201.165.132]:22927 "EHLO
	abc.logicbricks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589Ab3EHRyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:54:47 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2013 13:54:47 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: fb driver for logiCVC
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Wed, 8 May 2013 19:36:14 +0200
Message-ID: <9D79B9A9194389468A922F618415D0A401229CA9@abc.xylon.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: fb driver for logiCVC
Thread-Index: Ac5MEomtL9yZpNS+RH2g0FQG6c+tkQ==
From: "Davor Joja" <Davor.Joja@logicbricks.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am sending link to frame buffer driver for Xylon "logiCVC" FPGA IP
core, so I would kindly ask for driver review.
logiCVC is Configurable Video Controller developed for Xilinx FPGA
devices.
logiCVC device together with xylonfb driver is widely used in Xilinx
Targeted Referent Designs on Zynq SoC platforms (ZC702, ZC706, ZED, TED,
Xilinx customers and Xilinx university program) and on custom projects
from Xylon and Xylon customers.

Driver implements platform and open firmware registration types.
It has built in interface with V4L2 ADV7511 HDMI transmitter driver for
handling EDID and miscellaneous clock generator SI570 driver.
I would seek an advice for above mentioned and other issues which will
get to surface in review.

For now fb driver runs on 3.8 kernel (ARM architecture), and it was
tested in all its configurations with:
- Xylon test application
- fbdev - Frame buffer device test application
- DirectFB,
- QT
- Ubuntu 10.04 (16bpp and 32bpp color depth) Driver build was tested by
Open Source Technology Center.

Latest driver is available at
https://github.com/logicbricks/linux_kernel.git under
"drivers/video/xylon" and "include/linux" "Documentation (xylonfb
devicetree parameters)"
It is available on https://github.com/xilinx but not latest version.

I have placed on ftp.logicbricks.com logiCVC datasheet, application
note, current xylonfb driver user manual and test applications.
Username: xylonfb
Password: xylonfb

Regards,
Davor Joja
