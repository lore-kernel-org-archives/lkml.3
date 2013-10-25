Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3JYPDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:03:52 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38742 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab3JYPDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:03:50 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Subject: linux-next: Tree for Oct 25
Date: Fri, 25 Oct 2013 17:03:45 +0200
Message-Id: <1382713426-2680-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've uploaded today's linux-next tree to the master branch of the
repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131025 tag is also provided for convenience.

One new trivial conflicts and a new build failure caused by an incorrect
use of the genpool allocator.

Upon a request from Olof Johansson I've only included fixes for build
breakage as a result of interactions between the various trees. But
since I've fixed many of the other build failures already, I've pushed
those to a separate tag (next-20131025-fixes). That builds fine on x86
32-bit and 64-bit allmodconfigs as well as ARM and x86 default
configurations. Most of the PowerPC build errors have also been fixed.

Thierry
