Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbaFNQYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 12:24:15 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:45048 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbaFNQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 12:24:14 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: platforms: cell: cbe_thermal.c:  Cleaning up a variable is of the wrong type  
Date: Sat, 14 Jun 2014 18:25:10 +0200
Message-Id: <1402763111-23458-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable is of the wrong type, everywhere it is used it
should be an unsigned int rather than a int.

This was partly found using a static code analysis program called cppcheck.

Rickard Strandqvist (1):
  arch: powerpc: platforms: cell: cbe_thermal.c:  Cleaning up a variable is of the wrong type

 arch/powerpc/platforms/cell/cbe_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.7.10.4

