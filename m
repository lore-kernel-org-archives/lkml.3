Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3BAJdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:33:09 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:34633 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3BAJdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:33:06 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 1 Feb 2013 10:33:04 +0100
Message-ID: <CA+icZUU=Ra4j6-dWbfP2fZDfRb+onQWo3HrejMsqTYO4v62o1A@mail.gmail.com>
Subject: ext4-next: Backport of jbd2 fixes?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

will those JBD2 fixes in ext4.git#dev [1] get also into mainline kernel(s)?

[ Cut-n-paste out of tig ]

2013-01-31 13:00 Theodore Ts'o      │ o jbd2: track request delay statistics
2013-01-30 00:41 Theodore Ts'o      │ o jbd2: commit as soon as
possible after log_start_commit <--- T-b-me (Linux-Next + 3.8-rc5+)
2013-01-30 00:39 Eric Sandeen       │ o jbd2: don't wake kjournald
unnecessarily <--- T-b-me (Linux-Next + 3.8-rc5+)

I see no "CC: linux-stable"... and none of my Tested-by#s :-).

Thanks for taking care!

Regards,
- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=refs/heads/dev
