Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaL2TmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 14:42:21 -0500
Received: from lists.s-osg.org ([54.187.51.154]:42156 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaL2TmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 14:42:12 -0500
Message-ID: <54A1AE91.4020909@osg.samsung.com>
Date: Mon, 29 Dec 2014 12:42:09 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org,
        "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>,
        shuahkh@osg.samsung.com
Subject: [GIT PULL] kselftest fixes for 3.19
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following kselftest fix for 3.19.

thanks,
-- Shuah

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-3.19-fixes

for you to fetch changes up to 6898b627aab6ba553e6d8b40a0b1ddc43c48d42f:

  selftests/exec: Use %zu to format size_t (2014-12-22 11:11:36 -0700)

----------------------------------------------------------------
kselftest fixes for: 3.19

Fix exec test compile warnings.

----------------------------------------------------------------
Geert Uytterhoeven (1):
      selftests/exec: Use %zu to format size_t

 tools/testing/selftests/exec/execveat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
