Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbaDBKgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:36:10 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:58962 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006AbaDBKgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:36:08 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "=?iso-8859-1?Q?'Bruno_Pr=E9mont'?=" <bonbons@linux-vserver.org>
Cc: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
References: <001101cf4d30$782fa0f0$688ee2d0$@lucidpixels.com> <20140401222152.10af8cdf@neptune.home>
In-Reply-To: <20140401222152.10af8cdf@neptune.home>
Subject: RE: X.org doesn't start with 3.14: [KMS] drm report modesetting isn't supported
Date: Wed, 2 Apr 2014 06:36:06 -0400
Message-ID: <000701cf4e5f$5ac1be60$10453b20$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQF1ZmuraKg95HQcSEsKvqpLofvHeAJGwWO1m5+xzvA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Bruno Prémont [mailto:bonbons@linux-vserver.org]
> Sent: Tuesday, April 01, 2014 4:22 PM
> To: Justin Piszcz
> Cc: linux-kernel@vger.kernel.org; dri-devel@lists.freedesktop.org
> Subject: Re: X.org doesn't start with 3.14: [KMS] drm report modesetting
isn't
> supported
> 
> Hi Justin,
> 
> CC-ing dri-devel as more KMS/radeon people will see it there.

[ .. ]

My issue:
[    0.623399] [drm] Loading CEDAR Microcode
[    0.623461] r600_cp: Failed to load firmware "radeon/CEDAR_pfp.bin"
[    0.623517] [drm:evergreen_init] *ERROR* Failed to load firmware!
[    0.623573] radeon 0000:05:00.0: Fatal error during GPU init
[    0.623629] [drm] radeon: finishing device.

Somehow this option became unselected in my kernel configuration, although I
almost always usually run make oldconfig-- so I am not sure how it happened:
[ ]   Include in-kernel firmware blobs in kernel binary

Back to normal as per below:
-*- Userspace firmware loading support
 [*]   Include in-kernel firmware blobs in kernel binary
(radeon/CEDAR_me.bin radeon/CEDAR_pfp.bin radeon/CEDAR_rlc.bin
radeon/CYPRESS_uvd.bin)
External firmware (/lib/firmware) Firmware blobs root directory

# pwd
/lib/firmware/radeon
# ls -l *CEDAR*pfp*
-rw-r--r-- 1 root root 4480 Feb 22 16:50 CEDAR_pfp.bin
#

[ .. ]

Thank you && sorry for the noise!

Justin.

