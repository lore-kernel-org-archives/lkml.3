Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab3APBPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:15:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128Ab3APBPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:15:30 -0500
Message-ID: <50F5FF2F.70206@vlnb.net>
Date: Tue, 15 Jan 2013 20:15:27 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [ANNOUNCE]: SCST version 2.2.1 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:wrmZDupC9XHLDEYOtPZpcYDou0/V1RKcmV869lGEUgu
 FZzLAOI6Fn4WWjBx1c0+fLGaxXZV0LxnkWIPzxGcFrJgmhxf/a
 /2uaeCB0q3nd7YI1SIsKw2I30jw8I7Ma81I4NLqGlqEaQnbcg0
 6ujFZBf46nrPobbAKqNcexROn97oYjvSn8Rp+jWUyCo5hBiHCh
 VhhBLkFiG1ieAVTkuJNEGBqdPJRzR3lB2Bhceo2Qkj93Sz4Zfa
 bj9A9HfC/HZkUyFRllk4hUAshNfCtGPb9/KsGNDEML9u5QQVt/
 CTxolGBAeX637s2JJ+oJZSIqBCIGK9hyKcwM5Mggt1DmUk/lmZ
 PKyAVzJUhp73aWOuGSws=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCST version 2.2.1 has just been released. This release includes SCST core, target 
drivers iSCSI-SCST (iSCSI), qla2x00t (QLogic Fibre Channel), ib_srpt (InfiniBand 
SRP) and scst_local (local loopback-like access) as well as SCST management 
utility scstadmin.

SCST allows creation of sophisticated storage devices, which provide advanced 
functionality, like replication, thin provisioning, deduplication, high 
availability, automatic backup, etc. Another class of such devices are Virtual 
Tape Libraries (VTL) as well as other disk-based backup solutions. SCST created 
devices not limited by network interface only, but they can use any link 
supporting SCSI-style data exchange, like Fibre Channel or SAS. Majority of modern 
SAN appliances, especially higher end ones, are SCST based. It might well be that 
your favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Thanks to all who made it happen, especially Bart Van Assche, who prepared the 
packages!

Vlad

