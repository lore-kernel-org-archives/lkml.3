Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaGGSZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:25:06 -0400
Received: from plane.gmane.org ([80.91.229.3]:55840 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaGGSZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:25:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: 3.15.4 runs *significantly* slower than 3.15.3 on iMX233 CPU
Date: Mon, 07 Jul 2014 20:21:38 +0200
Message-ID: <lpeofi$1fl$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5dd560e1.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

maybe someone can help me to find the reason for this problem:

If I run my iMX233 development board with an 3.15.3 kernel, then the 
performance is much better as with an 3.15.4 kernel.

I have the first significant "hanging" here:

[    7.910000] sd 0:0:0:0: [sda] Attached SCSI removable disk
[   10.810000] random: nonblocking pool is initialized
[   24.310000] systemd[1]: systemd 214 running in system mode. (+PAM 
-AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ +SECCOMP 
-APPARMOR)

After booting up it takes several seconds between entering the username 
and the password while with version 3.15.3 the password prompt appears 
almost immediately after entering the username.

Please tell me if some additional information is needed.

Thank you very much in advance.

Greetings,

Manuel

