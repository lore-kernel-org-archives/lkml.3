Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3JWPP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 11:15:56 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:38220 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3JWPPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 11:15:55 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Subject: linux-next: Tree for Oct 23
Date: Wed, 23 Oct 2013 17:13:22 +0200
Message-Id: <1382541202-6614-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've uploaded today's linux-next tree to the master branch of the
repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131023 tag is also provided for convenience.

No new conflicts. I've fixed various build failures, so 32-bit and 64-bit
allmodconfigs build fine on x86. ARM and x86 default configurations also
build fine. Most of the patches to fix the build failures have been sent
to the respective maintainers.

Thierry
