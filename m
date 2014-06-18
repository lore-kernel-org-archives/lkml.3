Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965534AbaFRJ2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:28:18 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:39104 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965123AbaFRJ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:28:15 -0400
Date: Wed, 18 Jun 2014 10:28:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v4 1/7] mfd: axp20x: add AXP221 PMIC support
Message-ID: <20140618092806.GI23945@lee--X1>
References: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com>
 <1402990723-28138-2-git-send-email-boris.brezillon@free-electrons.com>
 <20140618083605.GQ21030@lee--X1>
 <53A15202.1070908@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A15202.1070908@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Boris BREZILLON wrote:
> On 18/06/2014 10:36, Lee Jones wrote:
> > On Tue, 17 Jun 2014, Boris BREZILLON wrote:
> >
> >> Add support for the AXP221 PMIC device to the existing AXP20x driver.
> >>
> >> The AXP221 defines a new set of registers, power supplies and regulators,
> >> but most of the API is similar to the AXP20x ones.
> >> The AXP20x irq chip definition is reused, though some interrupts are not
> >> available in the AXP221.
> >>
> >> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> >> ---
> >>  drivers/mfd/axp20x.c       | 64 ++++++++++++++++++++++++++++++++++++++++++----
> >>  include/linux/mfd/axp20x.h | 56 ++++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 115 insertions(+), 5 deletions(-)
> > Looks good to me now.
> >   Acked-by: Lee Jones <lee.jones@linaro.org>
> >
> > Can this go in independently to the other patches in the set?
> 
> Yes, as long as no one define an axp221 node in his DT.
> In this case axp221 regulators would be considered as axp20x ones (which
> might be a bit problematic), because axp20x-regulator driver does not
> test the axp variant before probing its regulators (this test is
> introduced in patch 3).

Then I'd prefer to wait and have the dependencies go in at the same
time.

Mark,
  As normal, I'm happy to create a shared branch between us.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
