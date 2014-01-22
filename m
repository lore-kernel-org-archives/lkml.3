Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaAVLfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:35:12 -0500
Received: from plane.gmane.org ([80.91.229.3]:53517 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbaAVLfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:35:10 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: shravan <shravanec2011@gmail.com>
Subject: ADC continous mode
Date: Wed, 22 Jan 2014 11:29:32 +0000 (UTC)
Message-ID: <loom.20140122T122840-441@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 61.12.19.99 (Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/28.0.1500.71 Chrome/28.0.1500.71 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi experts,
i am new to this area,
I am using amstrong 3.8.13 kernel in BBB
at first i loaded the device tree as below,

 echo cape-bone-iio > /sys/devices/bone_capemgr.*/slots

then i used analog pins however i am getting the fixed values that is values 
are not varying continously as i vary input analog voltage

if i go to this path
/sys/devices/ocp.2/44e0d000.tscadc/tiadc/iio:device0

and then ls -al gives me

total 0
drwxr-xr-x 3 root root    0 Jan  1 03:24 .
drwxr-xr-x 4 root root    0 Jan  1 03:24 ..
-r--r--r-- 1 root root 4096 Jan  1 03:27 dev
-rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage0_raw
-rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage1_raw
-rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage2_raw
-rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage3_raw
-rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage4_raw
-rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage5_raw
-rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage6_raw
-rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage7_raw
-r--r--r-- 1 root root 4096 Jan  1 03:25 name
drwxr-xr-x 2 root root    0 Jan  1 03:27 power
lrwxrwxrwx 1 root root    0 Jan  1 03:27 subsystem -> ../../../../../bus/iio
-rw-r--r-- 1 root root 4096 Jan  1 03:24 uevent

there is no mode directory and buffer directory in list . please help to 
configure ADC In continous mode. 

Thanks 
shravankumar

