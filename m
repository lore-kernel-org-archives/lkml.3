Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935831Ab3DKO1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:27:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34160 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932712Ab3DKO1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:27:07 -0400
Date: Thu, 11 Apr 2013 15:27:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 20/30] ASoC: samsung: convert to dmaengine API
Message-ID: <20130411142706.GB24971@opensource.wolfsonmicro.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <1365638712-1028578-21-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365638712-1028578-21-git-send-email-arnd@arndb.de>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 02:05:02AM +0200, Arnd Bergmann wrote:
> In order to build the exynos kernel with CONFIG_ARCH_MULTIPLATFORM,
> we must convert all users of the Samsung private DMA interface to
> the generic dmaengine API. This version of the patch adds the
> generic dmaengine API as an alternative to the existing samsung
> specific one. Once all the older platforms provide support for
> the common dmaengine interfaces, we can remove the old code.

There's generic ASoC dmaengine code which should be used instead of open
coding this.  Lars-Peter Clausen and Lee Jones have been working on
making this a totally generic driver, right now it's a library.
