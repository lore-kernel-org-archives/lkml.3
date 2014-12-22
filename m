Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaLVNSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 08:18:50 -0500
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:41992
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaLVNSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 08:18:49 -0500
X-Greylist: delayed 1007 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2014 08:18:48 EST
X-Originating-IP: [82.36.39.136]
X-Spam: 0
X-Authority: v=2.1 cv=dY0O3Bne c=1 sm=1 tr=0 a=h3ZJzbuz6X3s3VlFudNWSw==:117
 a=h3ZJzbuz6X3s3VlFudNWSw==:17 a=DrNGYBpgUcYA:10 a=N659UExz7-8A:10
 a=a5Gf7U6LAAAA:8 a=bgUkVmbCD3rZoZhqrOMA:9 a=pILNOxqGKmIA:10
Message-ID: <54981647.8010409@blueyonder.co.uk>
Date: Mon, 22 Dec 2014 13:01:59 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Subject: 3.19.0-rc1 nouvea build failure on GeForce GT 610 only
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   CHK     kernel/config_data.h
   CC [M]  drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.o
drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.c: In function 
‘nvd0_dmaobj_bind’:
drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.c:54:8: error: 
‘GM204_DISP_CORE_CHANNEL_DMA’ undeclared (first use in this function)
    case GM204_DISP_CORE_CHANNEL_DMA:
         ^
drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.c:54:8: note: each 
undeclared identifier is reported only once for each function it appears in
scripts/Makefile.build:257: recipe for target 
'drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.o' failed
make[4]: *** [drivers/gpu/drm/nouveau/core/engine/dmaobj/nvd0.o] Error 1
scripts/Makefile.build:402: recipe for target 'drivers/gpu/drm/nouveau' 
failed
make[3]: *** [drivers/gpu/drm/nouveau] Error 2
scripts/Makefile.build:402: recipe for target 'drivers/gpu/drm' failed
make[2]: *** [drivers/gpu/drm] Error 2
scripts/Makefile.build:402: recipe for target 'drivers/gpu' failed
make[1]: *** [drivers/gpu] Error 2
Makefile:938: recipe for target 'drivers' failed
make: *** [drivers] Error 2

01:00.0 VGA compatible controller: NVIDIA Corporation GF119 [GeForce GT 
610] (rev a1)

No problems on 2 other boxes with GeForce 8600 GT] (rev a1)
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

