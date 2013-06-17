Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab3FQPsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:48:24 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:42240 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3FQPsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <201306161741.17048.heiko@sntech.de>
References: <201306141741.46077.heiko@sntech.de>
	<201306161302.32156.heiko@sntech.de>
	<CACRpkdZxO-8rQPBRPsxAx8OBfwvh_BQuts7NAi379gMZG+1ocg@mail.gmail.com>
	<201306161741.17048.heiko@sntech.de>
Date: Mon, 17 Jun 2013 17:48:23 +0200
Message-ID: <CACRpkdZx9pjfqzn_keKTGGPsP1jHOY2=4OQX9mmymeo9EPn=Cg@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: rockchip: correctly handle arguments of
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

On Sun, Jun 16, 2013 at 5:41 PM, Heiko Stübner <heiko@sntech.de> wrote:

> Change the rockchip pinctrl driver to handle the arguments to the pull
> pinconfig options correctly. So only accept non-0 values for the
> pull options as the rockchip pin-controller can only turn pulls on and
> off (this via BIAS_DISABLE).
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
> changes since v1:
>  really respect the values for arguments of the pull options (aka 0 is not
>  meant to turn off a pull).
>  Replacing the patch also makes sure that no wrong knowledge stays in the
>  kernel via the old commit message, least somebody else reads it and takes
>  it as true.

OK took out the v1 and put in this v2 version instead...

Thanks!
Linus Walleij
