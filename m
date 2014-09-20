Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaITGjL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 02:39:11 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:52998 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaITGjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 02:39:10 -0400
Message-ID: <541D2108.1090308@vlnb.net>
Date: Fri, 19 Sep 2014 23:39:04 -0700
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20131118 Thunderbird/17.0.11
MIME-Version: 1.0
To: scst-devel <scst-devel@lists.sourceforge.net>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [ANNOUNCE]: SCST 3.0 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:J5qokUjar66ZHLG5BiebIbORS+rcFPjiCA3yrCz8H64
 2bUVNh00SiM51L/mYuZBuRPIpVMB+ZveO0u7QUd9pUwcZucvje
 PzTF3B1259FEoH7QFqePGSyZkm4fKqoNmMsbCN144z5nrNFYn7
 bBWSEee2ZKSd5a0YsBvXL8/cnFLwXkGKfre49dXdwzWq687HmX
 Ld6+H6sSZ+M0XW7e6IE7CS91YOHWpBn3KK58ZQQiZtgHEyAE22
 rsC4g3I+TQQWM2FPS4bfL2S0p0MGZ8xrzt2bxfbPRVpcsguT58
 9clJBsUeWElSd411BRIbBDB4KKCiEO2eMztDO7ILrfr3XkJPVx
 IyCwcGGFyZSt/skhtMYc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm glad to announce that SCST 3.0 has just been released. This release includes SCST 
core, target drivers iSCSI-SCST for iSCSI, including iSER support (thanks to 
Mellanox!), qla2x00t for QLogic Fibre Channel adapters, ib_srpt for InfiniBand SRP, 
fcst for FCoE and scst_local for local loopback-like access as well as SCST management 
utility scstadmin. Also separately you can download from Emulex development portal 
stable and fully functional target driver for the current generation of Emulex Fibre 
Channel adapters.

SCST is alternative SCSI target stack for Linux. SCST allows creation of sophisticated 
storage devices, which provide advanced functionality, like replication, thin 
provisioning, deduplication, high availability, automatic backup, etc. Majority of 
recently developed SAN appliances, especially higher end ones, are SCST based. It might 
well be that your favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Thanks to all who made it happen!

Vlad
