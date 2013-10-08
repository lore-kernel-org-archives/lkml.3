Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3JHNq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:46:27 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:58210 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab3JHNqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:46:19 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Subject: linux-next: Tree for Oct 8
Date: Tue,  8 Oct 2013 15:44:11 +0200
Message-Id: <1381239855-16314-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've uploaded today's linux-next tree to the master branch of the
repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131008 tag is also provided for convenience.

No new conflicts today. x86, ARM, PowerPC and MIPS default configurations
build fine. There were some build failures unrelated to the merge, most
of which I fixed and added as patches on top of the final merge.

Thierry
