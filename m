Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaHGTnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:43:08 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:43595 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaHGTnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:43:06 -0400
Date: Thu, 7 Aug 2014 21:42:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: mathieu.poirier@linaro.org
Cc: linus.walleij@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        robherring2@gmail.com, daniel.thompson@linaro.org, arve@android.com,
        john.stultz@linaro.org, pratikp@codeaurora.org, varshney@ti.com,
        Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, panchaxari.prasannamurthy@linaro.org,
        marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, Tony.Armitstead@arm.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10 v3] Coresight framework and drivers
Message-ID: <20140807194259.GB2351@ravnborg.org>
References: <1407435706-19441-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407435706-19441-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu.

Maybe I just missed it, but ...
> 
> As part of this patchset you will find:
> 
> . The return of non-configurable replicators.  Since they don't
>   show up on the AMBA bus we need to use the platform device model.
> . It is now possible to configure and use multiple sinks simultaneously.
> . The coresigh config entries have been moved to arch/arm/Kconfig.debug.
> . Documentation for bindings has been removed from this submission and 
>   will be sent separately.
> . "of_coresight.h" has been folded into "coresight.h".
> . Miscellaneous style problems have been addressed.

this introduction give me no clue what coresight is about.

I most likely do not need to know since this look to be arm specific,
but this kind of info is always nice to have included as a service
to the poor people that is not on-top of everything.

	Sam
