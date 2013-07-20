Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3GTQUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 12:20:52 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:39640 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab3GTQUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 12:20:51 -0400
MIME-Version: 1.0
In-Reply-To: <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
	<1374290388-19308-3-git-send-email-grant.likely@linaro.org>
Date: Sat, 20 Jul 2013 18:20:50 +0200
Message-ID: <CACRpkdb2bPQOD2CBzbF0K33mZZwKwGSCO6B4djesVd5DR-Z1tA@mail.gmail.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 5:19 AM, Grant Likely <grant.likely@linaro.org> wrote:

> Device tree bindings require a lot more attention than they used to.
> We've got a group of volunteers willing to take over maintaining
> bindings. This patch adds them to the MAINTAINERS file.
>
> This group still needs to work out a process for maintainership and how
> they are going to work together. I recommend that they set up a shared
> tree on git.kernel.org that they each have commit access to similar to
> the tip tree or the arm-soc tree, but it is up to them.
>
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Ian Campbell <ian.campbell@citrix.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: devicetree@vger.kernel.org

Excellent move.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
