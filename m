Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaHQSi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 14:38:28 -0400
Received: from mo-online.de ([89.238.66.174]:52750 "EHLO mo-online.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbaHQSiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 14:38:24 -0400
Date: Sun, 17 Aug 2014 20:29:56 +0200
From: Markus Osterhoff <mo@mo-online.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [TYPO 0/9] Several spellings and punctuations in Documentation
Message-ID: <20140817182956.GA4077@mo-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: linux-2.6.39.3
X-Mutt-Manual: http://www.mutt.org/doc/manual/manual.html
X-PGP-Key: http://mo-online.de/~osti/public.key
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reading some documentation to get acquainted with the Linux kernel
development, I encountered some spelling and punctuation, erm, mutants
that are addressed in this patch-set.

Patches are based on v3.17-rc1.

Since this is my first patch, any comments on style and email are
welcome.

Markus Osterhoff (9):
  [typo] spelling, punctuation in main README file
  [typo] MAINTAINERS: redundant full stop removed
  [typo] REPORTING-BUGS
  [typo] COPYING: form feeds removed
  [typo] CREDITS: capitalisation, punctuation
  [typo] Doc/kbuild/kconfig-language.txt: several spellings
  [typo] Doc/kbuild/kconfig-language.txt: sentence structure
  [typo] Doc/CodingStyle, BUG-HUNTING, 00-INDEX
  [typo] spelling, punctuation in Documentation/...

 COPYING                                   | 10 +++++-----
 CREDITS                                   |  4 ++--
 Documentation/00-INDEX                    |  4 ++--
 Documentation/BUG-HUNTING                 | 10 +++++-----
 Documentation/CodingStyle                 |  8 ++++----
 Documentation/HOWTO                       | 22 +++++++++++-----------
 Documentation/ManagementStyle             | 16 ++++++++--------
 Documentation/SecurityBugs                |  2 +-
 Documentation/SubmittingPatches           |  4 ++--
 Documentation/kbuild/kconfig-language.txt | 18 +++++++++---------
 MAINTAINERS                               |  2 +-
 README                                    |  4 ++--
 REPORTING-BUGS                            |  4 ++--
 13 files changed, 54 insertions(+), 54 deletions(-)

-- 
1.8.5.5

