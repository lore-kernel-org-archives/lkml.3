Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3JXQbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:31:35 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:54352 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab3JXQbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:31:33 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Subject: linux-next: Tree for Oct 24
Date: Thu, 24 Oct 2013 18:31:29 +0200
Message-Id: <1382632289-18523-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've uploaded today's linux-next tree to the master branch of the
repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131024 tag is also provided for convenience.

Quite a few new conflicts. Some of them non-trivial. I've fixed another
set of build failures, so 32-bit and 64-bit allmodconfigs build fine on
x86. ARM and x86 default configurations also build fine. PowerPC is in
pretty bad shape, mostly due to some OF header rework going on.

I'm somewhat short on time today, so I probably won't manage to send out
detailed conflict reports out today. I'll try to do that tomorrow,
though.

Thierry
