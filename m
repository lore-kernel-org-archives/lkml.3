Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbaDJQ0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:26:38 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:48072 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbaDJQ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:26:35 -0400
MIME-Version: 1.0
In-Reply-To: <1396360976-28657-3-git-send-email-heikki.krogerus@linux.intel.com>
References: <1396360976-28657-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1396360976-28657-3-git-send-email-heikki.krogerus@linux.intel.com>
Date: Thu, 10 Apr 2014 18:26:35 +0200
Message-ID: <CACRpkdatPrWKLNWV7mxxDMaW3xCEgSWqsBN-153c6CmGQz-ifg@mail.gmail.com>
Subject: Re: [PATCHv3 2/5] net: rfkill: gpio: remove unused and obsolete
 platform parameters
From: Linus Walleij <linus.walleij@linaro.org>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Chen-Yu Tsai <wens@csie.org>,
        Rhyland Klein <rklein@nvidia.com>, Marc Dietrich <marvin24@gmx.de>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 4:02 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:

> After upgrading to descriptor based gpios, the gpio numbers
> are not used anymore. The power_clk_name and the platform
> specific setup and close hooks are not used by anybody, and
> we should not encourage use of such things, so removing them.
>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
