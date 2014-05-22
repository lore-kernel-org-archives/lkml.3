Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaEVEKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:10:23 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:60777 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaEVEKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:10:21 -0400
Message-ID: <537D78A8.4030604@vlnb.net>
Date: Wed, 21 May 2014 21:10:16 -0700
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20131118 Thunderbird/17.0.11
MIME-Version: 1.0
To: scst-devel <scst-devel@lists.sourceforge.net>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [ANNOUNCE]: SCST 2.2 pre-release freeze
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:EN+RWlYPBZJPTNVXmzd706XfkWbmDsPgfT1OC1JPRm+
 n0267pHkbGbU7RROfhv9b1NWEOKkwfDF5+Cm7fiDZ9PoccXW5Q
 zXkl3zGiWlZ65/uDYzH174gJ2HFsNpKR+MGHue3/A6Tt2UO/3r
 4dyI0D+eBsTqZ+aRkD4KhPMizMnLVFenpgxPmB/VdqNh2kbGTU
 5i4BkPQHx7oy1XDT/37a4/IEas71FNWSjuw+2KbwDaPdhoLS8T
 zVSmorX2DisgUn9MRQWErfE6/ALBJhe8iXkRI+lY3DOTcpHzuA
 HSLBE/+rXpaNPj2gaYd3WHjMOnmpIL6biKspl90iwgXfHVEiv0
 h05uY6/jSFYPMZ4Fw4A4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm glad to announce SCST 3.0 pre-release code freeze in the SCST SVN branch 3.0.x

You can get it by command:

$ svn co https://scst.svn.sourceforge.net/svnroot/scst/branches/3.0.x

It is going to be released after few weeks of testing, if nothing bad found.

SCST is alternative SCSI target stack for Linux. SCST allows creation of sophisticated storage devices, which provide advanced functionality, like replication, thin provisioning, deduplication, high availability, automatic backup, etc. Majority of recently developed SAN appliances, especially higher end ones, are SCST based. It might well be that your favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Thanks to all who made it happen!

Vlad
