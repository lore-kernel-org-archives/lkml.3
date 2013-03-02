Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab3CBSWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 13:22:35 -0500
Received: from 77-175-125-29.FTTH.ispfabriek.nl ([77.175.29.125]:51535 "EHLO
	srv2.net.home" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752225Ab3CBSWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 13:22:34 -0500
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Mar 2013 13:22:33 EST
Message-ID: <513241AC.1080800@net.home>
Date: Sat, 02 Mar 2013 19:15:08 +0100
From: Vlad <vovan@vovan.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130223 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: NFS3/kerberos/ACL - strange problem
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Recently I've discovered quite strange issue with nfs v3 and ACL's.
While on the clients without updates everything works as expected, on
the clients with recent updates ACL's simply don't work:
- "ls" gives "Permission denied" error on folders with ACL's
- getfacl gives the same "permission denied" error
- on kerberos server I see strange errors while executing "ls" on the
client:
krb5kdc[2661]: TGS_REQ (4 etypes {18 17 16 23}) 192.168.1.2:
UNKNOWN_SERVER: authtime 0,  xxx@NET.HOME for
nfsacl/nfs.net.home@NET.HOME, Server not found in Kerberos database


I can track what has been updated but the list is too long... I'd
appreciate any thoughts on this issue.

Regards,
Vlad.
