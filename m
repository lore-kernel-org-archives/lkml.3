Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3FYNOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:14:30 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53226 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3FYNO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:14:29 -0400
MIME-Version: 1.0
In-Reply-To: <201306251455.42495.heiko@sntech.de>
References: <201306251455.01540.heiko@sntech.de>
	<201306251455.42495.heiko@sntech.de>
Date: Tue, 25 Jun 2013 15:14:28 +0200
Message-ID: <CACRpkdZcGDWWU6gAh13dTAaf=UrZZu3nNuCadj0W6xvWpkeV7A@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: more clarifications for generic pull configs
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

On Tue, Jun 25, 2013 at 2:55 PM, Heiko Stübner <heiko@sntech.de> wrote:

> PULL_PIN_DEFAULT is meant for hardware completely hiding any pull
> settings from the driver, so that it's really only possible to turn
> the pull on or off, but it not being possible to determine any
> pull settings from software.
>
> Also the binding-documentation for the pull arguments did not match
> the changes to the expected values.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Patch applied.

Yours,
Linus Walleij
