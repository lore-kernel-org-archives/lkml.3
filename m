Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3LaKUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 05:20:36 -0500
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:45778
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab3LaKUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 05:20:35 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Dec 2013 05:20:34 EST
X-Originating-IP: [82.36.39.136]
X-Spam: 0
X-Authority: v=2.1 cv=WI/xXxcR c=1 sm=1 tr=0 a=h3ZJzbuz6X3s3VlFudNWSw==:117
 a=h3ZJzbuz6X3s3VlFudNWSw==:17 a=6vexxxhns_QA:10 a=T1TLPjPyWI4A:10
 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=8nJEP1OIZ-IA:10 a=a5Gf7U6LAAAA:8
 a=sa0oFtYSy7YA:10 a=aR16PxjQAAAA:8 a=RMvpqy4VbVQiR7yz-BgA:9 a=wPNLvfGTeEIA:10
 a=TRaWWqdqQ4oA:10
Message-ID: <52C29918.4060102@blueyonder.co.uk>
Date: Tue, 31 Dec 2013 10:14:48 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>,
        opensuse factory list <opensuse-factory@opensuse.org>
Subject: Possible 3.13-rc nouveau regression with GT 560 Ti
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System x86_64 with openSUSE 13.1.
X.Org version: 1.14.99.905

openSUSE 12.2 kernels boot successfully into a graphical screen, login 
to KDE4, etc. all normal.

3.13-rc kernels boot fully with X running but no graphical screen and it 
freezes in VC with not all the startup messages displayed but I could 
ssh in from another box to check dmesg and logs.

Xorg.0.log which I thought I had saved did not log an error.

dmesg said "nouveau Playlist update failed".

Changed the GeForce GT 560 Ti for a GeForce 8600 GT and 3.13.0-rc6 is up 
and running.

If necessary I can go back to the GT 560 Ti to gather dmesg and Xorg log 
information.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

