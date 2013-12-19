Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3LSRUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:20:44 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55434 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3LSRUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:20:42 -0500
Date: Thu, 19 Dec 2013 17:20:36 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [PATCH 3/5] MFD: twl6040: reg_defaults support for regmap
Message-ID: <20131219172036.GD16145@lee--X1>
References: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
 <1385733827-19831-4-git-send-email-peter.ujfalusi@ti.com>
 <20131129160032.GC26982@lee--X1>
 <20131218185659.GL31886@sirena.org.uk>
 <20131219090632.GA24932@lee--X1>
 <20131219105240.GU31886@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131219105240.GU31886@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enjoy!

> > What -rc are you currently based on?
> 
> Using -rc1 makes life easier, it'll be a new branch.

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.linaro.org/people/ljones/mfd.git tags/ib-asoc-3.14-1

for you to fetch changes up to c7f9129d22940720141d1f1e958a51142eff9d21:

  mfd: twl6040: reg_defaults support for regmap (2013-12-19 17:01:11 +0000)

----------------------------------------------------------------
Immutable branch between ASoC and MFD - for v3.14 merge window

----------------------------------------------------------------
Peter Ujfalusi (1):
      mfd: twl6040: reg_defaults support for regmap

 drivers/mfd/twl6040.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 89 insertions(+), 3 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
