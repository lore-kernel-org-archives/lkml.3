Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbaJNVdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:33:11 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:38390 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaJNVdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:33:09 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Oct 2014 14:32:47 -0700
Message-ID: <CALCETrWbig8zfjQqLz2g7BMi3X6_x0gy+73K9hHzY66SD75s6g@mail.gmail.com>
Subject: [GIT PULL] CVE-2014-7970
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus-

Eric asked me to forward this fix to you.  Please pull.

The following changes since commit 0d0826019e529f21c84687521d03f60cd241ca7d:

  mnt: Prevent pivot_root from creating a loop in the mount tree
(2014-10-14 14:27:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git CVE-2014-7970

for you to fetch changes up to 0d0826019e529f21c84687521d03f60cd241ca7d:

  mnt: Prevent pivot_root from creating a loop in the mount tree
(2014-10-14 14:27:19 -0700)

Thanks,
Andy
