Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3FFTSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:18:54 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39731 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3FFTSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:18:52 -0400
Date: Thu, 6 Jun 2013 12:18:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: Re: Atmel updates to atmel_mxt_ts touch controller driver - v5
 Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
 Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130606191847.GB4542@core.coreip.homeip.net>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 06:36:53PM +0100, Nick Dyer wrote:
> The following patches are an updated series of patches to the atmel_mxt_ts
> touch driver. They should apply cleanly to input/next.
> 
> This is a combined patchset, I've been working to merge my changes with the
> changes from the Chromium team. It's undergone a lot of testing and review
> over the last few months and I believe it is now ready to go upstream.
> 
> Most of these changes have been maintained and tested out-of-tree in some form
> for a long time. I apologise for the backlog.
> 
> We also provide a set of user-space utilities as open source which are
> available from github and work well with this driver:
>   https://github.com/atmel-maxtouch/obp-utils
> 
> You can see the in-between versions at
>   https://github.com/ndyer/linux/
> 

Daniel, Henrik,

Any comments befroe I start pulling parts of this in?

Thanks.

-- 
Dmitry
