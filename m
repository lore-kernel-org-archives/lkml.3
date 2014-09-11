Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaIKRdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:33:05 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35113 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaIKRdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:33:02 -0400
Date: Thu, 11 Sep 2014 10:32:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: atmel_mxt_ts - fix merge in DT documentation
Message-ID: <20140911173256.GA36295@core.coreip.homeip.net>
References: <1407372486-25881-1-git-send-email-javier.martinez@collabora.co.uk>
 <1407372486-25881-2-git-send-email-javier.martinez@collabora.co.uk>
 <53E37329.4020002@itdev.co.uk>
 <53E4E41D.4070703@collabora.co.uk>
 <53EDF6B4.7080804@collabora.co.uk>
 <53EE307E.8060507@itdev.co.uk>
 <53EE319A.1030304@wwwdotorg.org>
 <5411B73E.4040404@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411B73E.4040404@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 03:52:46PM +0100, Nick Dyer wrote:
> On 15/08/14 17:13, Stephen Warren wrote:
> >>> Any comments on this? I would really appreciate if you can expand on how
> >>> this DT property is supposed to be used so I can re-spin the atmel support
> >>> patch for Peach boards.
> >>
> >> The below patch improves the documentation for the gpio-property.
> > 
> > That patch makes sense, and is a nice description,
> > Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> Hi Dmitry-
> 
> Something went a bit wrong in merging f5940231a - there's a bit of repeated
> text that's been introduced.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>

Hmm, not sure how I messed this up, but I will queue the patch for the
next push.

Thanks.

-- 
Dmitry
