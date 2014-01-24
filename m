Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaAXO3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:29:32 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:56651 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaAXO3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:29:31 -0500
X-Greylist: delayed 2152 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2014 09:29:31 EST
From: Shawn Starr <Shawn.Starr@statpro.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [3.13-rc/78] random SIGBUS errors + 3.14-rc0 - KVM/QEMU - CPU hang
 issues
Thread-Topic: [3.13-rc/78] random SIGBUS errors + 3.14-rc0 - KVM/QEMU - CPU
 hang issues
Thread-Index: Ac8ZCylrAWL4nXvWS/WqFt/urjmRag==
Date: Fri, 24 Jan 2014 13:53:28 +0000
Message-ID: <2D0D6BCF6E60AC409111CEB14208943C0104BA28@TORINTEXCMBXP1.STATNET.statpro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.10.52]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

After a couple days of uptime, with Google Chrome + Flash. This has happened twice, will crash with a SIGBUS and subsequent launches of Google Chrome will SIGBUS. In addition other programs may or may not SIGBUS but the whole system becomes unstable until a full reboot. I only see kaudit logs from kernel but nothing looks unusual and there are no other noticed messages indicating anything wrong.

Anyone else noticed SIGBUS issues w/ 3.13-rcX (-rc8 or final?)

For 3.14-rc0 in Fedora (rawhide non-debug repo), spinning up a VM w/ KVM causes kernel to report CPU hang by 'qemu' process, it's early in the 3.14 cycle so I expect things to be wild a bit but wanted to report that if anyone else hasn't noticed yet.

Thanks,

Shawn Starr
Sr. Linux Administrator 
StatPro | Toronto
Tel. +1 (416) 619-3972 | Fax. +1 (416) 598-9530
Twitter. @statprogroup
www.statpro.com

Looking for a bit of holiday cheer? Watch StatPro's latest video

StatPro Canada Inc. registered Office: 33 Yonge Street, Suite 1101, Toronto ON, M5E 1G4. StatPro Canada Inc. is a member of StatPro Group plc. 



This message is private and confidential. If you have received this message in error, please notify us and remove it from your system. Any views or opinions presented in this email are solely those of the author and might not represent those of StatPro. Warning: Although StatPro has taken reasonable precautions to ensure no viruses are present in this email, the company cannot accept responsibility for any loss or damage arising from the use of this email or attachments.
