Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661AbaH1LRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:17:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932901AbaH1LRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:17:49 -0400
Date: Thu, 28 Aug 2014 13:17:47 +0200
From: chrubis@suse.cz
To: ltp-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, lwn@lwn.net
Subject: [LTP] [ANNOUNCE] The Linux Test Project has been released for AUGUST
 2014
Message-ID: <20140828111746.GA23303@rei.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good news everyone,

the Linux Test Project test suite stable release for *August 2014* has
been released.

Since the last release 311 patches by 24 authors were merged.

Notable changes are:

* New testcases and improved coverage for: madvise, waitid, timerfd_*,
  getcwd, sched_setaffinity, sendfile, vmsplice, rename, renameat, open,
  openat, readlink, readlinkat, utime, wait, utimes, truncate, fstatfs,
  statvfs, statfs, splice, tee, setpgid, sbrk, readdir, setresgid,
  setresuid, rmdir, perf_event_open, ...

* Continued effort to cleanup old code:
  - many CRAY, SGI, ... ifdefs were removed
  - the test library headers were cleaned up a bit
  - several testcases were cleaned up or rewritten from a scratch

* The TCONF (testcase not appropriate for current configuration) test
  status is now propagated to the test exit value and included in
  the testrun results. (previously it was reported as passed)

* Testcases utilizing a block device can now prepare a loopback device
  automatically in the test setup.

* LTP test library has gained API to easily propagate test result from a
  child process to a parent process.

* Linux containers testcases were cleaned up.

* The can network test were fixed and cleaned up.

* The isofs testcases were fixed and cleaned up.

* Test messages for failures now contain source code filename and line.

* If test gets an unexpected signal the message contains not only the
  signal number but also symbolic name such as SIGINT.

* Various fixes for failures on Btrfs filesystem, on PPC64 LE, SPARC64
  and inside of KVM virtual machine.

* And many more smaller fixes and enhancements.

The latest version of the test-suite contains 3000+ tests for the Linux
and can be downloaded at:

http://sourceforge.net/projects/ltp/files/LTP%20Source/ltp-20140828/

The project pages as well as GIT repository are hosted on GitHub for
quite some time now:

https://github.com/linux-test-project/ltp
http://linux-test-project.github.io/

If you ever wondered how to write a LTP testcase, don't miss our
(continuously updated) developer documentation at:

https://github.com/linux-test-project/ltp/wiki/Test-Writing-Guidelines
https://github.com/linux-test-project/ltp/wiki/BuildSystem

Patches, new tests, bugs, comments or questions should go to
to our mailing list at ltp-list@lists.sf.net.

-- 
Cyril Hrubis
chrubis@suse.cz
