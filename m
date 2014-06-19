Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbaFSRNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:13:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25988 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbaFSRNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:13:51 -0400
Message-ID: <53A31A47.5010904@oracle.com>
Date: Thu, 19 Jun 2014 13:13:43 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] liblockdep fixes for v3.15
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux.git liblockdep-fixes

for you to fetch changes up to b2f8bdb50a426aa104f7a57ca823589869b8da6f:

  tools/liblockdep: fix comparison of a boolean value with a value of 2 (2014-06-19 13:08:10 -0400)

----------------------------------------------------------------
zhangdianfang (1):
      tools/liblockdep: fix comparison of a boolean value with a value of 2

 tools/lib/lockdep/preload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
