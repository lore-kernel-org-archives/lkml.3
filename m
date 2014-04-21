Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaDULWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 07:22:16 -0400
Received: from SD88.btc-net.bg ([212.39.90.88]:38940 "HELO sd88.btc-net.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751718AbaDULVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 07:21:52 -0400
From: =?koi8-r?B?8MzBzcXOIPDF1NLP1w==?= <plamen@petrovi.no-ip.info>
To: <linux-kernel@vger.kernel.org>
Subject: kernel panic during boot - 3.14.1, root is btrfs
Date: Mon, 21 Apr 2014 14:21:27 +0300
Message-ID: <000d01cf5d53$d6394560$82abd020$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="koi8-r"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac9dU3zpKs7v/qwNSJ6oCNDWCXZT+A==
Content-Language: bg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!
I was trying to move several systems which have their root formatted as
btrfs from 3.13.x to 3.14.x and the kernel panicked during boot.
Is there anything special that needs to be done as to prepare an
in-use-btrfs-root for kernel >=3.14 ?
I bisected the problem to a btrfs commit, although I'm not entirely sure its
100% correct.
The systems are one physical machine and a couple of virtual ones. Since I
bisected this the physical one was converted to XFS root - it's a production
machine with real users.
More details on bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=74261
Greg KH says that 3.13.11 will be the last of the series, and advises to
move on to 3.14.x - but currently that is impossible for me (bar converting
the root to different FS).
Can someone think of something to help this situation?

P.S. Please, CC me as I'm not subscribed to the kernel mailing list.
---------------------------------
Plamen Petrov

