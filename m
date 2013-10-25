Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab3JYNFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:05:53 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:46864 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab3JYNDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:03:51 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mark Brown <broonie@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the mfd-lj tree
Date: Fri, 25 Oct 2013 15:03:41 +0200
Message-Id: <1382706224-8859-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382706224-8859-1-git-send-email-treding@nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <1382706224-8859-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the mfd-lj tree got conflicts in

	sound/soc/codecs/mc13783.c

caused by commits 9f6f0af (ASoC: mc13783: add spi errata fix), fd792f8
(mfd: mc13xxx: Move SPI erratum workaround into SPI I/O function) and
2d9215c (ASoC: mc13783: Use regmap directly from ASoC).

I fixed it up and the diff turned up empty, so I think it can't be all
that wrong.

Thanks,
Thierry
