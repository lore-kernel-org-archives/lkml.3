Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbaISSRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 14:17:30 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51356 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbaISSR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 14:17:28 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, olof@lixom.net, arm@kernel.org, mporter@linaro.org,
        bcm@fixthebug.org, jonathar@broadcom.com, sbranden@broadcom.com,
        rjui@broadcom.com, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, hauke@hauke-m.de,
        swarren@wwwdotorg.org, computersforpeace@gmail.com,
        marc.ceeeee@gmail.com, cernekee@gmail.com, gregory.0xf0@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] ARM: mach-bcm: offer a new maintainer and process
Date: Fri, 19 Sep 2014 11:17:11 -0700
Message-Id: <1411150632-25695-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

As some of you may have seen in the news, Broadcom has recently stopped
its mobile SoC activities. Upstream support for Broadcom's Mobile SoCs
was an effort initially started by Christian Daudt and his team, and then
continued by Alex Eleder and Matter Porter assigned to a particular landing
team within Linaro to help Broadcom doing so.

As part of this effort, Christian and Matt volunteered for centralizing pull
requests coming from the arch/arm/mach-bcm/* directory and as of today, they
are still responsible for merging mach-bcm pull requests coming from brcmstb,
bcm5301x, bcm2835 and bcm63xx, creating an intermediate layer to the arm-soc
tree.

Following the mobile group shut down, our group (in which Brian, Gregory, Marc,
Kevin and myself are) inherited these mobile SoC platforms, although at this
point we cannot comment on the future of mobile platforms, we know that our
Linaro activities have been stopped.

We have not heard much from Christian and Matt in a while, and some of our pull
requests have been stalling as a result. We would like to offer both a new
maintainer for the mobile platforms as well as reworking the pull request
process:

- our group has now full access to these platforms, putting us in the best
  position to support Mobile SoCs questions

- over time, we think that the brcmstb, bcm5301x, bcm63xx and now Cygnus code
  bases will represent the major bulk of the mach-bcm code changes submitted,
  mobile SoCs being in deep maintenance mode

- we want to keep our submission pace high, and keep a smooth and responsive
  process in place for other maintainers such as Hauke Merthens and Stephen
  Warren and now Scott Branden and his team for Cygnus/Northstar+.

- there is little to no code sharing within mach-bcm, so we think each group
  of maintainers should send individual pull requests towards Arnd and Olof,
  the only conflicts they should ever have to resolve are for the Makefile and
  Kconfig files, not different than any other pull requests

Ideally, we would like Christian and Matt to acknowledge that change, if we
cannot get an answer within the next 3 weeks, we think this change
should go in to unblock the current situation.

Florian Fainelli (1):
  MAINTAINERS: add a third maintainer to mach-bcm

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

-- 
1.9.1

