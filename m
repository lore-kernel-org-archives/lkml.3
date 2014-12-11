Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737AbaLKE7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:59:30 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40455 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaLKE73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:59:29 -0500
Date: Wed, 10 Dec 2014 20:59:03 -0800
From: Darren Hart <dvhart@infradead.org>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org
Subject: Re: [RESEND PATCH v5 0/5] acerhdf: adding new models, appropriate
 governor and minor clean up
Message-ID: <20141211045903.GB82668@vmdeb7>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1417184452-11884-1-git-send-email-peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417184452-11884-1-git-send-email-peter@piie.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 03:20:47PM +0100, Peter Feuerer wrote:
> Hi Darren,
> 
> please apply this series of patches.
> 
> It is intended to:
> 
>   * Introduce "manual mode" support (Patch 1 & 2), which is needed to control
>     the fan of a few new models.
> 
>   * Add an appropriate thermal governor (Patch 3).  Manipulating and
>     fiddling around with the step-wise governor has been a very fragile thing
>     in the past and as it broke again, I used the opportunity to add a two
>     point thermal governor which implements the actual fan handling required by
>     acerhdf and puts from my point of view things straight.
> 
>   * Do some minor clean up like:
>       - adding second trip point for critical temperature (Patch 4)
>       - removing _t suffix from struct which isn't typedef and replace unsigned
>         char by u8 (Patch 5)
> 
> Thanks and kind regards,
> peter 
> 
> Peter Feuerer (5):
>   acerhdf: Adding support for "manual mode"
>   acerhdf: Adding support for new models
>   acerhdf: Use bang-bang thermal governor
>   acerhdf: added critical trip point
>   acerhdf: minor clean up

Queued to for-next. Thanks!

-- 
Darren Hart
Intel Open Source Technology Center
