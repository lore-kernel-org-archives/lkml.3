Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaJBSjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:39:12 -0400
Received: from mout.gmx.net ([212.227.15.19]:52590 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbaJBSjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:39:08 -0400
Date: Thu, 2 Oct 2014 20:39:03 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>
Subject: [GIT PULL] parisc late fix for v3.17
Message-ID: <20141002183903.GA1250@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:j2xpA/reJkvfpDn4JIeLByLEsSYMfAwwxPZcPEsB0DjfS/Im/qp
 vJgkmAWT1a0Mc5q3Ac+6k1jRVdzqTZ+koTE7VcZ2LAbOws+u9pHYZYOOlpH8/t4q+ltzbHH
 oihIMS430mzqt0qViFBBu/iKI5gYSdHatS1ed/Y+4feRJzETs9ZQ4nHlp0gDOZadjomXpyq
 I09VOOOLoSppz1iikKFUg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

can you please pull 
  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.17-8

to fetch one late but trivial patch to fix the serial console on parisc
machines which got broken during the 3.17 release cycle?

Thanks,
Helge

Changelog:
Fix serial console for machines with serial port on superio chip

----------------------------------------------------------------
Helge Deller (1):
      parisc: Fix serial console for machines with serial port on superio chip

 drivers/parisc/superio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
