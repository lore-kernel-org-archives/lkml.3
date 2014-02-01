Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbaBAUeo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 15:34:44 -0500
Received: from mail-yk0-f175.google.com ([209.85.160.175]:41563 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbaBAUem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 15:34:42 -0500
MIME-Version: 1.0
Date: Sat, 1 Feb 2014 15:34:42 -0500
X-Google-Sender-Auth: hDYNoGBcA2hxKzaBtl7voRQYSkk
Message-ID: <CAJvTdKnmHyA3RojM_QOrF=az=3-dKzU_BQV+RxN2=R8erzo5+Q@mail.gmail.com>
Subject: [GIT PULL] turbostat update for Linux-3.14 merge
From: Len Brown <lenb@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these patches to update the turbostat utility.

thanks!
Len Brown, Intel Open Source Technology Center

The following changes since commit 7e22e91102c6b9df7c4ae2168910e19d2bb14cd6:

  Linux 3.13-rc8 (2014-01-12 17:04:18 +0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to 3b4d5c7fec0a0b1bbf56d3b8337770fa30f4d1ad:

  tools/power turbostat: introduce -s to dump counters (2014-02-01
15:24:28 -0500)

----------------------------------------------------------------
Andy Shevchenko (2):
      tools/power turbostat: remove unused command line option
      tools/power turbostat: introduce -s to dump counters

Dirk Brandewie (1):
      turbostat: Add option to report joules consumed per sample

Josh Triplett (8):
      turbostat: Don't put unprocessed uapi headers in the include path
      turbostat: Don't attempt to printf an off_t with %zx
      turbostat: Use GCC's CPUID functions to support PIC
      turbostat: Check return value of fscanf
      turbostat: Add a helper to parse a single int out of a file
      turbostat: Factor out common function to open file and exit on failure
      turbostat: Clean up error handling; disambiguate error messages;
use err and errx
      turbostat: Add a .gitignore to ignore the compiled turbostat binary

Len Brown (1):
      turbostat: run on HSX

 tools/power/x86/turbostat/.gitignore  |   1 +
 tools/power/x86/turbostat/Makefile    |   2 +-
 tools/power/x86/turbostat/turbostat.c | 441 +++++++++++++++++++---------------
 3 files changed, 244 insertions(+), 200 deletions(-)
 create mode 100644 tools/power/x86/turbostat/.gitignore
