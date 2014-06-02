Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaFBVkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:40:04 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33954 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaFBViB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:38:01 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 0/7] ARM: SoC material for 3.16, first batch
Date: Mon,  2 Jun 2014 14:04:03 -0700
Message-Id: <1401743050-7379-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's the first batch of arm-soc material for 3.16. There are a couple
more branches but they depend on shared contents with Russell's tree,
so we'll send that up after he has had his material merged.

Again, like last merge window, the bulk of contents is in device tree
updates. We've even had a couple of SoCs go in that didn't require enough
code changes that I noticed it when I was sifting through the material
writing up the tags, which is good news. It's not a primary goal that we
can do quite this much only with DT updates, but it's still good to see.

There are a few conflicts, some due to add/add from our different branches,
and a few of them because we've had new changes not always properly based on
cleanups and not caught it in time. Nothing that should be too messy to fix up.

We've been holding back Samsung from adding new SoC support until they
sorted out their multiplatform support, which they now have done. We're
very happy to be able to build an Exynos-enabled kernel together with
the other platforms now (Tegra, i.MX, OMAP, and all the others). This
also means that their slight backlog of SoC support is now picked up so
we've got a bunch of clock drivers and other things for their 3250 and
5410/5420/5800 series of chips.

I've documented the conflicts in each email, and I've pushed a
"resolved-for-3.16" branch with our proposed resolutions.


