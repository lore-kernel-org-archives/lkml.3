Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbaFYMDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:03:38 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:42745 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaFYMDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:03:37 -0400
Date: Wed, 25 Jun 2014 13:03:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH] pwm-backlight: use devm_gpiod_get_optional()
Message-ID: <20140625120331.GE13518@lee--X1>
References: <1403687898-26881-1-git-send-email-acourbot@nvidia.com>
 <20140625095447.GT13803@lee--X1>
 <20140625111346.GB21208@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140625111346.GB21208@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Thierry Reding wrote:
> On Wed, Jun 25, 2014 at 10:54:47AM +0100, Lee Jones wrote:
> > > Make use of the new devm_gpiod_get_optional() to simplify the probe
> > > code.
> > > 
> > > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > > ---
> > >  drivers/video/backlight/pwm_bl.c | 7 ++-----
> > >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > Looks good.  Applied, thanks.
> 
> Technically pwm_bl.c is my turf. However I only adopted it way back when
> the backlight subsystem was orphaned, but it seems Jingoo, Bryan and you
> are taking good care of it these days, so perhaps it would be a good
> idea to move it back to your custody?

Yeah, the whole 'driver maintainer' sketch could get pretty complex.
It's pretty clean-cut in the PWM subsystem as only one exists, but
Backlight and MFD have a whole bunch, and I don't usually wait for
them to Ack/Nack before applying or providing review comments.

I'm happy to play it however you like really.  I'm sure the boys and I
can handle it if you so wish.  Even better if you would say in the
MAINTAINERS file and provide review comments when patches are
submitted.  I do think all 'drivers/video/backlight' changes should go
in via the Backlight tree though.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
