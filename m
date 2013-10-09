Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3JIOQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:16:37 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:49582 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3JIOQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:16:33 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Subject: linux-next: Tree for Oct 9
Date: Wed,  9 Oct 2013 16:14:22 +0200
Message-Id: <1381328067-1593-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've uploaded today's linux-next tree to the master branch of the
repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131009 tag is also provided for convenience.

Gained a few conflicts, but nothing too exciting. x86, ARM, PowerPC and
MIPS default configurations build fine. There were some build failures
unrelated to the merge, most of which I fixed and added as patches on
top of the final merge.

Thierry
