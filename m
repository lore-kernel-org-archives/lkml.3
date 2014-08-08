Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbaHHQuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:50:14 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42728 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbaHHQrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:47:42 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL 0/7] ARM: SoC changes for 3.17
Date: Fri,  8 Aug 2014 09:47:52 -0700
Message-Id: <1407516479-1251-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 2.0.1.473.gc4d58ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A moderately sized set of branches this merge window for us, about 750
patches in total. There are several fairly large cleanups, and a net
negative delta(!)

 1014 files changed, 39452 insertions(+), 42425 deletions(-)

Most of the removal comes from two Samsung platforms being taken out
(together with a couple of legacy drivers used only by them), but there's
other stuff too -- removal and diet of some OMAP drivers and header
files, the final folding of Marvell Kirkwood into the mvebu platform,
removal of the legacy atmel pwm driver and a few more things like that.

The format is nearly the same as always: I describe the conflicts in
each email and I have pushed a 'resolved-3.17' branch if you want to
compare. Most branches are free of conflicts, the main exception is the
SoC branch and it's not horrible to deal with either.

I did include one patch interspersed with the branches (6/7 is a patch),
it's something Stephen was carrying locally and I think this is better to
handle this way than for us to do a backmerge to handle it ourselves. I'll
leave it up to you if you prefer to fold it into the 5/7 merge or apply
it separately.

More detailed descriptions in each pull request. I also anticipate having
another short branch of misc small cleanups that we have held off applying
for the second week of the merge window, but nothing major. This is by
far the bulk of the contents.

Please pull!

Thanks,

-Olof

