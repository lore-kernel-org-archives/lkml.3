Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3FPK2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 06:28:39 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:42763 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3FPK2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 06:28:38 -0400
MIME-Version: 1.0
In-Reply-To: <201306141742.49923.heiko@sntech.de>
References: <201306141741.46077.heiko@sntech.de>
	<201306141742.49923.heiko@sntech.de>
Date: Sun, 16 Jun 2013 12:28:37 +0200
Message-ID: <CACRpkdYiMNJUtz5NmaJu-XOdfErC4FGCP8+_VwX-=2MQbsPfuA@mail.gmail.com>
Subject: Re: [PATCH 2/5] pinctrl: clarify some dt pinconfig options
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 5:42 PM, Heiko Stübner <heiko@sntech.de> wrote:

> The bias-pull-* options use values > 0 to indicate that the pull should
> be activated and optionally also indicate the strength of the pull.
> Therefore use an default value of 1 for these options.
>
> Split the low-power-mode option into low-power-enable and -disable.
>
> Update the documentation to describe the param arguments better.
>
> Wrong default options
> Reported-by: James Hogan <james.hogan@imgtec.com>
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Patch applied.

Yours,
Linus Walleij
