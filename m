Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab3JGPUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:20:49 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:54904 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3JGPUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:20:46 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Subject: linux-next: Tree for Oct 7
Date: Mon,  7 Oct 2013 17:18:43 +0200
Message-Id: <1381159127-11067-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've uploaded today's linux-next tree to the master branch of the
repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131007 tag is also provided for convenience.

No new conflicts today. i386, x86_64 and ARM default configurations did
build fine. There were some build failures unrelated to the merge, most
of which I fixed and added as patches on top of the final merge.

Thierry
