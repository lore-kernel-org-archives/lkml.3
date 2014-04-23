Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaDWNHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:07:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbaDWNHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:07:39 -0400
Date: Wed, 23 Apr 2014 15:06:53 +0200
From: chrubis@suse.cz
To: ltp-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, lwn@lwn.net
Subject: [LTP] [ANNOUNCE] The Linux Test Project has been released for APRIL
 2014
Message-ID: <20140423130653.GA24742@rei>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good news everyone,

The Linux Test Project test suite stable release for *April 2014* has
been released.

Since the last release 210 patches by 27 authors were merged.

Notable changes are:

* Continued effort to cleanup old testcases
  (about 30 testcases were cleaned up/rewritten)

* 20 new syscall testcases
  15 existing testcases increased in coverage
  (pselect, mprotect, mknodat, fchonwat, linkat, fanotify, inotify, fcntl, ...)

* new tcp_fastopen, rcutorture and acpi_cpufreq testcases

* out-of-tree build as well as cross compilation were fixed

* bashism in runltp and few scripts was fixed
  (should work fine on Debian with dash now)

* ext4 features tests were fixed and added to default run

* few testcases were fixed not to incorrectly fail on Btrfs

* and many more smaller fixes


The latest version of the test-suite contains 3000+ tests for the Linux
OS and can be downloaded at:

http://sourceforge.net/projects/ltp/files/LTP%20Source/ltp-20140422/

The project pages as well as GIT repository are hosted on GitHub for
quite some time now:

https://github.com/linux-test-project/ltp
http://linux-test-project.github.io/

If you ever wondered how to write a LTP testcase, don't miss our
developer documentation at:

https://github.com/linux-test-project/ltp/wiki/Test-Writing-Guidelines
https://github.com/linux-test-project/ltp/wiki/BuildSystem

Patches, new tests, bugs, comments or questions should go to
ltp-list@lists.sf.net

-- 
Cyril Hrubis
chrubis@suse.cz
