Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3LSQjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:39:03 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:41379 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932067Ab3LSQi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:38:59 -0500
Date: Thu, 19 Dec 2013 17:38:57 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: arno@natisbad.org (Arnaud Ebalard)
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
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
Message-ID: <20131219173857.0a546b99@linux.lan.towertech.it>
In-Reply-To: <87siton6ke.fsf@natisbad.org>
References: <87siton6ke.fsf@natisbad.org>
Organization: Tower Technologies
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 17:34:09 +0100
arno@natisbad.org (Arnaud Ebalard) wrote:

> I never heard of *listed* RTC maintainer during all the review process
> on rtc-linux list (v0 sent in october); I dug the list archives and when
> this previously happened, someone else (e.g. Andrew Morton) was kind
> enough to handle the patches:

 Yes, Andrew usually pick those. I do not maintain a separate tree
 due to most RTCs being specifit to a subsytem.

> 
>   http://www.spinics.net/lists/arm-kernel/msg292187.html

 Regarding your patch, please do not add entries to /proc.
 Use sysfs if you need.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

