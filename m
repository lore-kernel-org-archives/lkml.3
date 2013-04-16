Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935774Ab3DPKYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:24:13 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39728 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3DPKYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:24:08 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [REPOST PATCH] spi: s3c64xx: let device core setup the default pin configuration
To: Doug Anderson <dianders@chromium.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, heiko@sntech.de,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Ben Dooks <ben-linux@fluff.org>, Mark Brown <broonie@kernel.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1366083777-9118-1-git-send-email-dianders@chromium.org>
References: <1362570130-14084-1-git-send-email-thomas.abraham@linaro.org> <1366083777-9118-1-git-send-email-dianders@chromium.org>
Date: Tue, 16 Apr 2013 11:24:02 +0100
Message-Id: <20130416102402.DF3493E14C0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013 20:42:57 -0700, Doug Anderson <dianders@chromium.org> wrote:
> From: Thomas Abraham <thomas.abraham@linaro.org>
> 
> With device core now able to setup the default pin configuration,
> the pin configuration code based on the deprecated Samsung specific
> gpio bindings is removed.
> 
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>

Applied, thanks.

g.

