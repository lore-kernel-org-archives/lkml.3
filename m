Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaLZL5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 06:57:09 -0500
Received: from mout.gmx.net ([212.227.15.18]:62260 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbaLZL5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 06:57:06 -0500
Date: Fri, 26 Dec 2014 12:56:53 +0100
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>
Subject: [GIT PULL] parisc fix for v3.19
Message-ID: <20141226115653.GA1050@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Provags-ID: V03:K0:hOcJl5EvV6ZIpG12CEXCi2CQjN2mbfee2xscf6dMfu52RfiD+fd
 sKidExQ/j0JS64SbbGFsnqqdn9Ygt5lNM/25OiKQsNIypGBtefRHWEGUzlhk34/Rz5Qiu7d
 FKo8JYkcXGhfKqZz1KWQnf+4CMNqjgJaZrJvZ3YC5wtg/acww8aijui358WuNTB1nrfAxPe
 nBuGpDPGT3ZsQ663Qt7pw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull one patch for the parisc architecture for kernel 3.19 from 

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.19-1

This patch unbreaks the kernel compilation on parisc with gcc-4.9.

Thanks,
Helge

----------------------------------------------------------------
John David Anglin (1):
      parisc: fix out-of-register compiler error in ldcw inline assembler function

 arch/parisc/include/asm/ldcw.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)
