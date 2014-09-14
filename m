Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaIOMfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:35:09 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:51880 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaIOMfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:35:08 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michal Marek <mmarek@suse.cz>, Rob Landley <rob@landley.net>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCHv2 0/2] Documentation/kbuild/headers_install.txt: update documentation
Date: Sun, 14 Sep 2014 22:26:59 +0200
Message-Id: <cover.1410712841.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please find some updates to headers_install.txt. In particular the
commands to list the architectures are removed, per Sam Ravnborg's
request.

Changes from v1 [1]:
- remove the shell commands to list architectures with 'asm' headers
  (in a dedicated patch)
- patch to update documentation now only fixes the various paths
  for the headers.

[1] http://lkml.kernel.org/r/cover.1405246007.git.ydroneaud@opteya.com

Yann Droneaud (2):
  Documentation/kbuild/headers_install.txt: remove obsolete instructions
  Documentation/kbuild/headers_install.txt: update installation paths

 Documentation/kbuild/headers_install.txt | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Rob Landley <rob@landley.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
-- 
1.9.3

