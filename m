Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaHTP6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:58:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45105 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaHTP6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:58:20 -0400
X-Greylist: delayed 2263 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Aug 2014 11:58:20 EDT
Date: Wed, 20 Aug 2014 16:20:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86 platform driver update
Message-ID: <20140820152034.GA3616@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This clearly shouldn't have been merged. No excuse on my part.

The following changes since commit 186e4e89a0922d75fba476f15b723e541cc34bea:

  platform/x86: Enable build support for toshiba_haps (2014-08-16 01:23:56 -0700)

are available in the git repository at:

  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to 8039aabb6c9f802bca04cc77ca210060a5b53916:

  Revert "platform/x86/toshiba-apci.c possible bad if test?" (2014-08-20 08:18:18 -0700)

----------------------------------------------------------------
Matthew Garrett (1):
      Revert "platform/x86/toshiba-apci.c possible bad if test?"

 drivers/platform/x86/toshiba_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


-- 
Matthew Garrett | mjg59@srcf.ucam.org
