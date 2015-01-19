Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbbASMYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:24:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbbASMYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:24:00 -0500
Date: Mon, 19 Jan 2015 13:23:10 +0100
From: Cyril Hrubis <chrubis@suse.cz>
To: ltp-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org
Cc: lwn@lwn.net, akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: The Linux Test Project has been released for JANUARY 2015
Message-ID: <20150119122310.GA27065@rei>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

God news everyone,

the Linux Test Project test suite stable release for *January 2015* has
been released.

Since the last release 139 patches by 21 authors were merged.

Notable changes are:

* Fixes and enhancements of network testcases by Alexey Kodanev

* New testcases for mount, network and ipc namespaces by Matus Marhefka

* New testcase for fanotify ignore masks

* New policy and library helpers to install and access testcase datafailes

* Use of coccinelle and spatch to fix bugs and cleanup old code

* And many more smaller fixes and enhancements


If you are not familiar with LTP there is a nice article at LWN.net
https://lwn.net/Articles/625969/.

The latest version of the test-suite contains 3000+ tests for the Linux
and can be downloaded at:

http://sourceforge.net/projects/ltp/files/LTP%20Source/ltp-20150119/

The project pages as well as GIT repository are hosted on GitHub for
quite some time now:

https://github.com/linux-test-project/ltp
http://linux-test-project.github.io/

If you ever wondered how to write a LTP testcase, don't miss our developer
documentation at:

https://github.com/linux-test-project/ltp/wiki/Test-Writing-Guidelines
https://github.com/linux-test-project/ltp/wiki/BuildSystem

Patches, new tests, bugs, comments or questions should go to
to our mailing list at ltp-list@lists.sourceforge.net.

-- 
Cyril Hrubis
chrubis@suse.cz
