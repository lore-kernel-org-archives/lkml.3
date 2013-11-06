Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab3KFS3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:29:23 -0500
Received: from mout.gmx.net ([212.227.17.20]:62231 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab3KFS3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:29:22 -0500
Message-ID: <527A8A7E.1050906@gmx.de>
Date: Wed, 06 Nov 2013 19:29:18 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: cpufreq@vger.kernel.org
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: does niced processes scales frequency too at the ondemand governor
 ?
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:7FvJpbFRpaemyeRdeirfSnsgfZmv4Uva705Lz8vXIW7cCpmTA0U
 8ZWSV53jf6Z6fikIciVgruDTcWyd1EHmilJ/vM1/T1Wm6p0HrOK6ZLWSrEIJAWT5aMQxRQW
 YNBCMqGOvpLWBfe9mp1kyhL92Q91FOY+rh5ZpwPrzws91vT69iSRkcuVmyh2cRPKAgUyb8N
 hGBJWtz1ZYLUNK1Lhe+Qw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a Gentoo Linux at a 4-core CPU (i5) I realize, that compiling
packages using -j4 usually needs twice as long, if I run 4 BOINC
processes in the back ground (nice -n 19) too. Even considering effects
of invalidation of cache data this seems a too big impact in my eyes.

It looks for me like that the BOINC processes scales down the frequency,
when they are running. This behaviour however would be wrong IMO. The
frequency should be scaled just by the non-niced foreground processes,
right ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
