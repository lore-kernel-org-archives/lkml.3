Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaA1PQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:16:01 -0500
Received: from ra.se.axis.com ([195.60.68.10]:38367 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbaA1PQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:16:00 -0500
Date: Tue, 28 Jan 2014 16:15:55 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cris-kernel@axis.com
Subject: [GIT PULL] CRIS correction for 3.14
Message-ID: <20140128151555.GA17210@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus!

Please pull for a correction of the CRIS commits for 3.14.
One include too much was removed.

Thanks!

The following changes since commit 54c0a4b46150db1571d955d598cd342c9f1d9657:

  Merge branch 'akpm' (incoming from Andrew) (2014-01-27 21:17:55 -0800)

are available in the git repository at:


  git://jni.nu/cris tags/cris-correction-for-3.14

for you to fetch changes up to cd065a010a97e3c330d1ded9af551664c9689b19:

  CRISv10: Readd missing header (2014-01-28 15:14:35 +0100)

----------------------------------------------------------------
CRIS correction for 3.14

----------------------------------------------------------------
Jesper Nilsson (1):
      CRISv10: Readd missing header

 arch/cris/arch-v10/kernel/process.c | 1 +
 1 file changed, 1 insertion(+)

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
