Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaHEWSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 18:18:30 -0400
Received: from mout.gmx.net ([212.227.15.19]:55997 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbaHEWS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 18:18:29 -0400
Message-ID: <53E15832.6040303@gmx.de>
Date: Wed, 06 Aug 2014 00:18:26 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: kernel 3.16: is /sys/../hwmonX/temp1_input a moving target ?
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:JRgYSBMOolkmugc5WIMEWVIUAMdX99iVwT8Gs8myts0RTe30Pph
 xHFyig+rbbJSeeRZMXpiQdZ46uH6ZSopxJ1DyJo8BugCArO0Yp9v8+vTAv606vriHXO5Avx
 nqM6kbg9mLwbXvMo5KChEsYYZaBCxydif7yVi4t5Dt3MJ6+fJtJk9+PjY9HqoS4LQedoKqs
 SIjY2P7e97kbyrsDAK3/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yesterday I had to configure this for thinkfan :

/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp1_input

today it switched back to 

/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input

This makes it hard to have a valid /etc/thinkfan.conf

:-(

-- 
Toralf

