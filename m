Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3FPKbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 06:31:44 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:52228 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3FPKbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 06:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <201306141743.55811.heiko@sntech.de>
References: <201306141741.46077.heiko@sntech.de>
	<201306141743.55811.heiko@sntech.de>
Date: Sun, 16 Jun 2013 12:31:42 +0200
Message-ID: <CACRpkdZaSng72gpULBtpPKvYw+7jp2rePFv==xGQrWHqBsHrFg@mail.gmail.com>
Subject: Re: [PATCH 4/5] pinctrl: dynamically alloc temp array when parsing dt
 pinconf options
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

On Fri, Jun 14, 2013 at 5:43 PM, Heiko Stübner <heiko@sntech.de> wrote:

> Allocating the temorary array in pinconf_generic_parse_dt_config on stack
> might cause problems later on, when the number of options grows over time.
> Therefore also allocate this array dynamically to be on the safe side.
>
> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Patch applied.

Yours,
Linus Walleij
