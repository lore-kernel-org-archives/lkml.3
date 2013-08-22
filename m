Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab3HVCL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:11:57 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:40579 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab3HVCL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:11:56 -0400
Message-ID: <52157368.1000801@gmail.com>
Date: Wed, 21 Aug 2013 21:11:52 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wladislav Wiebe <wladislav.kw@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [GIT PULL] Devicetree fix for 3.11
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this single fix for a missing memory initialization in DT 
unflattening code.

Rob

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://sources.calxeda.com/kernel/linux.git tags/devicetree-fixes-for-3.11

for you to fetch changes up to 9e40127526e857fa3f29d51e83277204fbdfc6ba:

  of: fdt: fix memory initialization for expanded DT (2013-08-21 20:05:49 -0500)

----------------------------------------------------------------
For DT unflattening, add missing memory initialization. This is needed
for arches like PPC that use memblock_alloc. This appears to have been
an issue for some time, but is a somewhat limited usecase of OF_DYNAMIC.

----------------------------------------------------------------
Wladislav Wiebe (1):
      of: fdt: fix memory initialization for expanded DT

 drivers/of/fdt.c | 2 ++
 1 file changed, 2 insertions(+)
