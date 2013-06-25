Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab3FYNPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:15:40 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:37368 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3FYNPj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:15:39 -0400
MIME-Version: 1.0
In-Reply-To: <201306251456.12150.heiko@sntech.de>
References: <201306251455.01540.heiko@sntech.de>
	<201306251456.12150.heiko@sntech.de>
Date: Tue, 25 Jun 2013 15:15:38 +0200
Message-ID: <CACRpkdb8C=hR3JP9cpo4Hvj176AwGJ16M9o9Wd40AjTfP+9aEA@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: set unit for debounce time pinconfig to usec
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

On Tue, Jun 25, 2013 at 2:56 PM, Heiko Stübner <heiko@sntech.de> wrote:

> Currently the debounce time pinconfig option uses an unspecified
> "time units" unit. As pinconfig options should use SI units and a
> real unit is also necessary for generic dt bindings, change it
> to usec. Currently no driver is using the generic pinconfig option
> for this, so the unit change is safe to do.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Patch applied.

Yours,
Linus Walleij
