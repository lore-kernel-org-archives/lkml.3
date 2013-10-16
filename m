Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761526Ab3JPSx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:53:59 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:50806 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759947Ab3JPSx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:53:57 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Subject: linux-next: Tree for Oct 16
Date: Wed, 16 Oct 2013 20:51:38 +0200
Message-Id: <1381949500-501-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've uploaded today's linux-next tree to the master branch of the
repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131016 tag is also provided for convenience.

Gained two new conflicts, but nothing too exciting. x86 and ARM default
configurations as well as the x86 allmodconfig mostly build fine on the
final tree. There was a failure for the ARM at91x40_defconfig, but the
proper fix wasn't immediately obvious to me, so I've left it broken for
now.

Thierry
