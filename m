Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3FYNe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:34:27 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58986 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3FYNeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:34:25 -0400
MIME-Version: 1.0
In-Reply-To: <201306251457.10980.heiko@sntech.de>
References: <201306251455.01540.heiko@sntech.de>
	<201306251457.10980.heiko@sntech.de>
Date: Tue, 25 Jun 2013 15:34:25 +0200
Message-ID: <CACRpkdZ-3+1jKbOeCA3UZ0ZAjgROV38N94LALq4G5y9Ac=f0qQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] pinctrl: remove bindings for pinconf options needing
 more thought
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 2:57 PM, Heiko Stübner <heiko@sntech.de> wrote:

> Some options currently take arguments in unspecified driver-specific units.
> As pointed out by Stephen Warren, driver specific values should not be part
> of generic devicetree bindings describing the hardware.
>
> Therefore remove the critical bindings again, before they become part of
> an official release.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Patch applied.

Yours,
Linus Walleij
