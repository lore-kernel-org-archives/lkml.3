Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3HMQAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:00:42 -0400
Received: from mout.gmx.net ([212.227.15.19]:62943 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab3HMQAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:00:37 -0400
Message-ID: <520A5822.4080804@gmx.de>
Date: Tue, 13 Aug 2013 18:00:34 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130807 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: stable@vger.kernel.org
Subject: s2ram + X11 broken between 3.10.5 and 3.10.6 (i915)
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:2hobglr3vLv8VpRcTNvopJv9bmJVpLF1enTC9D9/NWWuNp0DPt2
 mGms3nqkdGADbL6a7S5EKuIBV1ngjtxEpnH9lyksNz834xuUnWPnuUaWp3r5WCc7Co8TlVH
 UpX+S/+AOUwH+P/8pYeJZId5iUR3UOtOHO0x27xfEYAbf5IJPibIQihlH0X6/2fRsW9Djb7
 pE0RzONo+jKvzPHur9+2g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At a ThinkPad T420 w/ a 32 bit stable Gentoo Linux and a started X11
server an attempt to s2ram results in a blank scree, a gloomy blinking
power button and no syslog message or something helpful . If the system
is booting w/o X11 then s2ram works.

s2ram in 3.10.5 works - and FWIW in 3.11-rc5 s2ram is fine.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
