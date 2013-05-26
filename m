Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3EZNev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 09:34:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56660 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3EZNeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 09:34:50 -0400
Date: Sun, 26 May 2013 15:34:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] amd64_edac fix for 3.10
Message-ID: <20130526133441.GB25870@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull.

Thanks.

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_fixes_for_3.10

for you to fetch changes up to bbb013b9200f0d860d2b353d47cc7b9f8f75fc8b:

  amd64_edac: Fix bogus sysfs file permissions (2013-05-21 09:13:11 +0200)

----------------------------------------------------------------
A sysfs file permissions correction.

----------------------------------------------------------------
Borislav Petkov (1):
      amd64_edac: Fix bogus sysfs file permissions

 drivers/edac/amd64_edac_inj.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
