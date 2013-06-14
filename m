Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3FNPh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:37:28 -0400
Received: from m59-178.qiye.163.com ([123.58.178.59]:36025 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3FNPhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:37:24 -0400
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, linux-kernel@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 0/2] Kernel file system client support for punch hole
Date: Fri, 14 Jun 2013 23:36:26 +0800
Message-Id: <1371224186-4809-1-git-send-email-liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQU5VQ0hLS0tLT0tLTk9ISUpIV1kJDhceCFlBWSgrPSQrOigoJDI1JDM#
	Oj8#KUFLVUtANiMkIj4oJDI1JDM#Oj8#KUFLVUtAKy8pJDU0JDI1JDM#Oj8#KUFJVUtAODQuNS8p
	IiQ4NUFLVUtAKT48MjQ1JDooMjpBS1VLQCspNC0yNTg#JDMuNTo1QUtVS0A*IjU6NjI4JDIrJDU0
	JDI1JDM#Oj8#KUFLVUtANi43LzIkKTgrLyQ*Mj09Pik#NS8kMjUkMz46Pz4pQUlVS0AyKyQvND86
	IiQ4NS8kSyRKS0tBS1VLQDIrJEokMzQuKSQ4NS8kSyRKS0tBS1VLQDIrJEokNjI1Li8#JDg1LyRL
	JEpLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQDIrJE4kNjI1Li8#JDg1LyRLJEpLQUtV
	S0AoLjkkPkFKVU5OQD01JCguOSQ#NSw0KT8oJDM3MSRKS0tJS0pBS1VJQ1kG
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSExKSUlPSUhCTkxMVTMWGhIX
	VRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHgY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements punch hole (fallocate) support for Ceph kernel
file system client.
We prepared two patches based on different kernel versions, one against
kernel 3.8-rc3, the other against the latest 3.10-rc5. It is because
unfortunately, we failed to set up a workable Ceph system with the client
based on the lastest code from Linux kernel git tree, for the server
side, we tried both the latest code from Ceph git tree and
the latest v0.61.3 release. The client will easily hang there without
any response, unless rebooting the machine.
We managed to set up a Ceph system with the client based on Linux 
kernel 3.8-rc3 and the server based on Ceph v0.61.3, so the patch 
against v3.8-rc3 has been under preliminary tests. However, the one 
against v3.10-rc5 not.
Comments are appreciated.  

