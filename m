Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbaE3NvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:51:11 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39615 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755963AbaE3NvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:51:08 -0400
Date: Fri, 30 May 2014 14:49:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: mathieu.poirier@linaro.org
Cc: linus.walleij@linaro.org, will.deacon@arm.com, arve@android.com,
        john.stultz@linaro.org, pratikp@codeaurora.org, varshney@ti.com,
        Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, panchaxari.prasannamurthy@linaro.org,
        arnd@linaro.org, marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        daniel.thompson@linaro.org
Subject: Re: [RFC PATCH 11/11] ARM: moving support for etb/etm to the
	"drivers" directory
Message-ID: <20140530134915.GP3693@n2100.arm.linux.org.uk>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org> <1401457391-12242-12-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401457391-12242-12-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 07:43:11AM -0600, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> Removing minimal support for etb/etm to favour an implentation
> that is more flexible, extensible and capable of handling more
> platforms.
> 
> Also removing the only client of the old driver.  That code can
> easily be replaced by entries for etb/etm in the device tree.
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

You say "moving" in the subject, but you are *re*moving it.  This is
misleading.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
