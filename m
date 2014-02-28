Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaB1VHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:07:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38781 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaB1VHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:07:42 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: ben@decadent.org.uk
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [v3.2.y][PATCH 0/1] cifs: set MAY_SIGN when sec=krb5
Date: Fri, 28 Feb 2014 16:07:34 -0500
Message-Id: <cover.1393535604.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1285723

Hi Ben,

Please consider including a backport of upstream commit 0b7bc84000d71f3647ca33ab1bf5bd928535c846 in the next v3.2.y release.  It was included upstream as of v3.9-rc1.  It has been tested and confirmed to resolve http://bugs.launchpad.net/bugs/1285723 .

commit 0b7bc84000d71f3647ca33ab1bf5bd928535c846
Author: Martijn de Gouw <martijn.de.gouw@prodrive.nl>
Date:   Wed Oct 24 11:45:46 2012 +0200

    cifs: set MAY_SIGN when sec=krb5

This commit has a requrement for commit 8830d7e07a5e38bc47650a7554b7c1cfd49902bf, so it does not apply cleanly to v3.2.  I performed a backport to avoid this requirement, which is in email 1/1.


Sincerely,
Joseph Salisbury

Joseph Salisbury (1):
  cifs: set MAY_SIGN when sec=krb5

 fs/cifs/connect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.7.9.5

