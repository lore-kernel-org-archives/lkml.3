Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab3KKFdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:33:04 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54662 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3KKFcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:32:55 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL 0/6] ARM: SoC branches for 3.13
Date: Sun, 10 Nov 2013 21:29:30 -0800
Message-Id: <1384147776-18735-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've got a slightly smaller than usual set of patches for 3.13. More
and more code is going through the driver trees so this is all good as
far as I am concerned.

We've broken up the main pull requests for this merge window in 6
branches in the usual categories. There are a few more merge conflicts
than ideal -- mostly because we didn't noticed in time that we forgot to
base a couple of the categories on top of the cleanup branches. None of
it is hairy, just somewhat annoying.

That's pretty much it. Pull requests to follow. Merge conflict
descriptions per pull request, and there's a sample merge pushed up as:

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git resolved-for-3.13


-Olof

