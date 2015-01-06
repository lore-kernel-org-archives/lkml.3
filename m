Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbbAFTfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:35:54 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:62865 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbbAFTfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:35:51 -0500
Message-ID: <54AC3913.9010701@mvista.com>
Date: Tue, 06 Jan 2015 13:35:47 -0600
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: [GIT PULL] IPMI: Fix warning
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1421c935df159c8b893e82dd81b329b8977c4e86:

  ipmi: Fix compile warning with tv_usec (2014-12-30 13:34:36 -0600)

are available in the git repository at:

  git://git.code.sf.net/p/openipmi/linux-ipmi tags/for-linus-3

for you to fetch changes up to 1421c935df159c8b893e82dd81b329b8977c4e86:

  ipmi: Fix compile warning with tv_usec (2014-12-30 13:34:36 -0600)

----------------------------------------------------------------
Fix a compile warning

----------------------------------------------------------------
 drivers/char/ipmi/ipmi_ssif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Thanks,

-corey
