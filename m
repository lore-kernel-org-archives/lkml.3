Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3B1WzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:55:08 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38221 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3B1WzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:55:06 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL 0/3] arm-soc: late changes for 3.9
Date: Thu, 28 Feb 2013 14:54:49 -0800
Message-Id: <1362092093-4839-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is a series of merge requests for arm-soc branches.

The first two are mostly normal changes, The OMAP changes came in late
before the merge window opened, so we wanted to let them sit for a few
more days in -next. The i.MX branch is a churny branch that I wanted to
keep separate and not have other code depend on, and thus held it off
to the second batch.

Final two pull requests are for the same code. As Arnd describes in the
tags, they are for a set of mvebu patches that depend on contents in
the MMC tree. We had pulled in part of the MMC branch as a dependency,
but unfortunately Chris Ball rebased it.

We're giving you the choice of taking the rebased version, or a
non-rebased-but-merged-and-fixed-up version to avoid dealing with the
excessive conflicts. The rebased one has the obvious benefit of not
having duplicate commits in the tree for the same changes, but, well,
it's rebased. Actual tree contents is identical though.

I've pushed a resolved branch for reference (late-branches-resolved)
in case you want to compare conflict resolutions.


Thanks,

-Olof

