Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab3IEFVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 01:21:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51999 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab3IEFV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 01:21:29 -0400
Message-ID: <522814D1.100@vlnb.net>
Date: Wed, 04 Sep 2013 22:21:21 -0700
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [ANNOUNCE]: Emulex SCST support for 16Gb/s FC and FCoE CNAs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:WwvVSRMUJEkWpq7dFGBqYtCAWbz1dzq2wST+6hVdrfx
 VNDio3cwQ2PjDnviTwyunZjZ+91nAw1XI8JkTXziy37592dgk/
 K64ETMxylDREh9G5ZorxYLBkLZl1FE8azVRECArACMg3RCvaGI
 fPER0p0Odt0ibkbRig+Lw/i3jceEip7FAcczfZR1S7YCdPE7qs
 T4d2R4IvyMxudgtTJ3OqSocx5u9/LFwkRw9t6cEADZyyd4+pow
 iAItO2m2j3RVnybkCc3aJy4Dj7/+fisNAAT5WE9bKTOUm0a1zN
 H7eKM1yInB+c3QZ6FI6zakOcgNvnIxRE4Iu09IijAqVr9OeSg=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm glad to announce that SCST support for 16Gb/s FC and FCoE Emulex CNAs is now
available as part of the Emulex OneCore Storage SDK tool set based on the Emulex SLI-4
API. Support for 16Gb/s Fibre Channel LPe16000 series and FCoE hardware using target
mode versions of the OneConnect FCoE CNAs is included. Documented for use with
RHEL/CentOS 6.x based distributions, ocs_fc_scst works with the stable SCST 2.2.1 as
well as the development versions of 2.2.x and 3.0.x. The driver code and documentation
are available on the Emulex web site at:
http://www.emulex.com/products/onecore-storage-software-development-kit/overview.html

Registration is required on the Developer Portal, but this is free.

Questions regarding this driver better to ask via the Developer Portal.

SCST is SCSI target mode stack for Linux. SCST allows creation of sophisticated storage
devices, which provide advanced functionality, like replication, thin provisioning,
deduplication, high availability, automatic backup, etc. Majority of recently developed
SAN appliances, especially higher end ones, are SCST based. It might well be that your
favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Vlad
