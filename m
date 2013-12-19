Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3LSRt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:49:28 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:42001 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035Ab3LSRt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:49:27 -0500
Date: Thu, 19 Dec 2013 18:49:24 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: arno@natisbad.org (Arnaud Ebalard)
Cc: Jason Cooper <jason@lakedaemon.net>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        rtc-linux@googlegroups.com, Pawel Moll <pawel.moll@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Peter Huewe <peter.huewe@infineon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Can someone Ack and queue a patch for RTC subsytem?
Message-ID: <20131219184924.13a12247@linux.lan.towertech.it>
In-Reply-To: <87sitoka39.fsf@natisbad.org>
References: <87siton6ke.fsf@natisbad.org>
	<20131219164624.GV2609@titan.lakedaemon.net>
	<87sitoka39.fsf@natisbad.org>
Organization: Tower Technologies
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 18:46:18 +0100
arno@natisbad.org (Arnaud Ebalard) wrote:

> > I don't mind routing it though mvebu/arm-soc since the only consumers
> > are currently mvebu boards, but I'd like to hear from Andrew that this
> > is ok.  
> 
> I will do what you think is the best.

 If the only consumers are mvebu boards, I believe it is correct to
 route though that tree. imho.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

