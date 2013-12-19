Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3LSSDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:03:09 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:42128 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789Ab3LSSDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:03:08 -0500
Date: Thu, 19 Dec 2013 19:03:02 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Arnaud Ebalard <arno@natisbad.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Huewe <peter.huewe@infineon.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <treding@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Guenter Roeck <linux@roeck-us.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Can someone Ack and queue a patch for RTC subsytem?
Message-ID: <20131219190302.4074c2ab@linux.lan.towertech.it>
In-Reply-To: <20131219180136.GX2609@titan.lakedaemon.net>
References: <87siton6ke.fsf@natisbad.org>
	<20131219173857.0a546b99@linux.lan.towertech.it>
	<87d2kslphr.fsf@natisbad.org>
	<20131219184024.2a649328@linux.lan.towertech.it>
	<20131219180136.GX2609@titan.lakedaemon.net>
Organization: Tower Technologies
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 13:01:36 -0500
Jason Cooper <jason@lakedaemon.net> wrote:

> That goes against the whole goal of the arm-soc devicetree conversion.
> For the past several years, we've been moving drivers _out_ of arch/arm/
> into the appropriate drivers/ area.  The goal of this was to unclutter
> arch/arm/, and to more readily see and remove code duplication by
> drivers.

 I meant in drivers/rtc but using another tree. 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

