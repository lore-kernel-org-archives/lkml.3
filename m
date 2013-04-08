Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935018Ab3DHTD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:03:57 -0400
Received: from mout.gmx.net ([212.227.17.22]:52244 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761152Ab3DHTDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:03:55 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/n18psDBTng3PvTxq59FG8hPTPdDkaZhnT2V5uw2
	bLs7PP5LJViv+R
Message-ID: <51631497.4070103@gmx.de>
Date: Mon, 08 Apr 2013 21:03:51 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130405 Thunderbird/17.0.5
MIME-Version: 1.0
To: netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.9-rc6 (only) one particular tap device putted into forwarding state
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I realized these new syslog messages at a 32 bit stable Gentoo, which have
4 configured TAP devices attached to a bridge :

2013-04-08T19:55:20.048+02:00 n22 kernel: br0: port 4(tap3) entered forwarding state
2013-04-08T19:55:20.048+02:00 n22 kernel: br0: port 4(tap3) entered forwarding state
2013-04-08T19:55:20.316+02:00 n22 kernel: br0: port 4(tap3) entered disabled state

This happened one time only and only for one device (for tap3, and all 4 devices are identical configured)
for one boot attempt till now - no configuration were changed.


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
