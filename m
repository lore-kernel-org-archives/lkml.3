Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaBRWpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:45:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37371 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaBRWpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:45:41 -0500
Message-ID: <5303E28A.8010200@oracle.com>
Date: Tue, 18 Feb 2014 16:45:30 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        JFS Discussion <jfs-discussion@lists.sourceforge.net>
Subject: [GIT PULL] jfs for 3.14-rc4
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c18f7b51200c3c8b76c63e391f9995b65ace9c83:

  jfs: fix generic posix ACL regression (2014-02-08 10:50:58 -0600)

are available in the git repository at:

  git://github.com/kleikamp/linux-shaggy.git tags/jfs-3.14-rc4

for you to fetch changes up to 844fa1b5f8493cff4b976fa7a5b9ebeeafdd75cc:

  jfs: set i_ctime when setting ACL (2014-02-13 15:56:05 -0600)

----------------------------------------------------------------
Another ACL regression. This one more subtle.

----------------------------------------------------------------
Dave Kleikamp (1):
      jfs: set i_ctime when setting ACL

 fs/jfs/acl.c | 2 ++
 1 file changed, 2 insertions(+)
