Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3DQXKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 19:10:19 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:55181 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3DQXKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 19:10:15 -0400
Message-ID: <516F2BD2.80507@kernel.org>
Date: Wed, 17 Apr 2013 19:10:10 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [git pull] idle patches for 3.9-rc7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this pair of small patches into 3.9-rc7.

This CPU-id should have been included in the
ones that we updated earlier in 3.9.
This pair of patches will allow this flavor of Haswell
to behave like the other flavors.

thanks!
Len Brown, Intel Open Source Technology Center

The following changes since commit a2362d24764a4e9a3187fc46b14e1d2cd0657700:

  mm/fremap.c: fix possible oops on error path (2013-03-14 17:00:39 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to 149c2319c6316d979de90ce2c8665e9c02d5927b:

  tools/power turbostat: additional Haswell CPU-id (2013-03-15 11:05:26 -0400)

----------------------------------------------------------------
Len Brown (2):
      intel_idle: additional Haswell CPU-id
      tools/power turbostat: additional Haswell CPU-id

 drivers/idle/intel_idle.c             | 1 +
 tools/power/x86/turbostat/turbostat.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

