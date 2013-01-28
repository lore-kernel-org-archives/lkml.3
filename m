Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3A1U4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 15:56:50 -0500
Received: from void.printf.net ([89.145.121.20]:41829 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab3A1U4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:56:47 -0500
From: Chris Ball <cjb@laptop.org>
To: Konstantin Dorfman <kdorfman@codeaurora.org>
Cc: "Zhang\, YiX X" <yix.x.zhang@intel.com>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: correct the EXCEPTION_EVENTS_STATUS vaule comment
References: <1A230AD7863570458C6CF2BE7CD6618B102BE5CB@SHSMSX102.ccr.corp.intel.com>
	<50EBD75F.7050805@codeaurora.org>
Date: Mon, 28 Jan 2013 15:56:09 -0500
In-Reply-To: <50EBD75F.7050805@codeaurora.org> (Konstantin Dorfman's message
	of "Tue, 08 Jan 2013 10:22:55 +0200")
Message-ID: <87sj5l81sm.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 08 2013, Konstantin Dorfman wrote:
> May be it is worth to change all this struct comments to be:
>
> u8	raw_exception_status;	/* EXT_CSD_EXP_EVENTS_STATUS */
>
> This will reference actual offset value from "include/linux/mmc/mmc.h"

I think I prefer having the literal numbers accessible, even though it
duplicates data, so I've taken Zhang's original patch for now.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
