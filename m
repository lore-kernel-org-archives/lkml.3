Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3IIWmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 18:42:39 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59272 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3IIWmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 18:42:38 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 0/3] ARM: SoC: Second round of changes for v3.12
Date: Mon,  9 Sep 2013 15:42:32 -0700
Message-Id: <1378766555-9679-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a 2nd round of changes from ARM SoC land.

The main thing of note (or of potential annoyance factor) here is the
handful of conflicts in PULL 2/3 coming from platform changes
conflicting with driver changes going in to the V4L tree.  I've listed
them in detail in that pull request, and we will work with the
platform maintainer on the workflow to avoid this in the future.

For future reference, when it comes to these conflicts, do you want to
see a summary of the suggested resolutions, a published branch with
the resolutions, both or neither?  Just curious.

Kevin
