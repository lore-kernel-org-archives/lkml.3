Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3L0CVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 21:21:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:45467 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3L0CVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 21:21:16 -0500
X-AuditID: cbfee68f-b7f156d00000276c-fc-52bce4108e23
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rashika Kheria'" <rashika.kheria@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Josh Triplett'" <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Eric Miao'" <eric.y.miao@gmail.com>
References: <20131216112110.GA4849@rashika> <20131216142423.GB24172@leaf>
In-reply-to: <20131216142423.GB24172@leaf>
Subject: Re: [PATCH] drivers: video: Remove unused function
 genericbl_limit_intensity() in generic_bl.c
Date: Fri, 27 Dec 2013 11:21:04 +0900
Message-id: <000301cf02aa$4b1afef0$e150fcd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac76aos/bCy4fT/FS5yQwvHYqev45AIPz61A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zY12BJ3uCDD6v0LGYs34Nm8WOtuNs
	FpcXXmK1+L8g3+JE3wdWi8u75rBZrHv4gsli0eLf7Bbr599ic+D02DnrLrvHqwt3WDxuvbb1
	ODHjN4tH35ZVjB7Hb2xn8vi8SS6APYrLJiU1J7MstUjfLoEr49/5y2wFa/kr7qxZxdTAeIOn
	i5GTQ0LAROLWzfVMELaYxIV769lAbCGBZYwS63rUYGqWXVjP3MXIBRRfxCjxeuo5KOcXo8T0
	JVMYQarYBNQkvnw5zN7FyMEhIhAnse2dFUgNs8BsJombD6ezQkz1lPj8YDMziM0poCUxaUoX
	C4gtLJAp0dr9BSzOIqAq0dHxBMzmFbCV2HRsLTuELSjxY/I9FpD5zALqElOm5IKEmQW0JZ68
	u8AKEpYACj/6qwtxgZHEz0kVEBUiEvtevGMEuUZCoJdD4uLlJawQmwQkvk0+xALRKiux6QAz
	xLuSEgdX3GCZwCgxC8neWQh7ZyHZOwvJhgWMLKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcx
	QmK7fwfj3QPWhxiTgbZPZJYSTc4Hpoa8knhDYzMjC1MTU2Mjc0sz0oSVxHnvP0wKEhJITyxJ
	zU5NLUgtii8qzUktPsTIxMEp1cBo3G13Lelzq5HJp//HUnc+5NjOse5jZs3j5RJW2gue+fr+
	9Xn5gZvx7ndhoU9Rz0sOflT8uNlepuNyU9i9yssrrjy6L7U1wOHyU4GUeQsPlau8SmKecEZK
	WbpgGmvgxMssnrlLk2cUeYf4Xty67+Rb08Ops/zmXRKae1tE6UHj5lMm4UHdXAvOK7EUZyQa
	ajEXFScCABZrp8IDAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jAV2BJ3uCDC70q1vMWb+GzWJH23E2
	i8sLL7Fa/F+Qb3Gi7wOrxeVdc9gs1j18wWSxaPFvdov182+xOXB67Jx1l93j1YU7LB63Xtt6
	nJjxm8Wjb8sqRo/jN7YzeXzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDdJmSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCOMePf+ctsBWv5K+6sWcXUwHiDp4uRk0NCwERi2YX1zBC2mMSFe+vZuhi5OIQEFjFKvJ56
	jhnC+cUoMX3JFEaQKjYBNYkvXw6zdzFycIgIxElse2cFUsMsMJtJ4ubD6awgNUICnhKfH2wG
	m8opoCUxaUoXC4gtLJAp0dr9BSzOIqAq0dHxBMzmFbCV2HRsLTuELSjxY/I9FpD5zALqElOm
	5IKEmQW0JZ68u8AKEpYACj/6qwtxgZHEz0kVEBUiEvtevGOcwCg0C8mcWQhzZiGZMwtJxwJG
	llWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwanjmdQOxpUNFocYBTgYlXh4HTbsCRJiTSwr
	rsw9xCjBwawkwvv5ClCINyWxsiq1KD++qDQntfgQYzLQlxOZpUST84FpLa8k3tDYxMzI0sjM
	wsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGH0fni70+enT6Fl0xueEhsOtjbWc
	C945FO99fcBBSvL3uVthE1p5eqz3vtv6ek2dwdUU8Q+m6xsTmgz3vdrMGGR1qOp1sGKbZO6d
	5umxtUGb7eYsONLLf6vgi87B/GC/5KDPNQfmPl6gv1ZRbOkSKb28Zykrpqjff6wsoBKevej2
	lIM98+OX5iixFGckGmoxFxUnAgDxex7mYQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 16, 2013 11:24 PM, Josh Triplett wrote:
> On Mon, Dec 16, 2013 at 04:51:10PM +0530, Rashika Kheria wrote:
> > Removes unused function genericbl_limit_intensity() in
> > backlight/generic_bl.c.
> >
> > This eliminates the following warning in backlight/generic_bl.c:
> > drivers/video/backlight/generic_bl.c:59:6: warning: no previous prototype for
> ‘genericbl_limit_intensity’ [-Wmissing-prototypes]
> >
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

(+cc Andrew Morton, Eric Miao)

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
> >  drivers/video/backlight/generic_bl.c |   18 ------------------
> >  1 file changed, 18 deletions(-)
> >
> > diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
> > index 5d8d652..67dfb93 100644
> > --- a/drivers/video/backlight/generic_bl.c
> > +++ b/drivers/video/backlight/generic_bl.c
> > @@ -52,24 +52,6 @@ static int genericbl_get_intensity(struct backlight_device *bd)
> >  	return genericbl_intensity;
> >  }
> >
> > -/*
> > - * Called when the battery is low to limit the backlight intensity.
> > - * If limit==0 clear any limit, otherwise limit the intensity
> > - */
> > -void genericbl_limit_intensity(int limit)
> > -{
> > -	struct backlight_device *bd = generic_backlight_device;
> > -
> > -	mutex_lock(&bd->ops_lock);
> > -	if (limit)
> > -		bd->props.state |= GENERICBL_BATTLOW;
> > -	else
> > -		bd->props.state &= ~GENERICBL_BATTLOW;
> > -	backlight_update_status(generic_backlight_device);
> > -	mutex_unlock(&bd->ops_lock);
> > -}
> > -EXPORT_SYMBOL(genericbl_limit_intensity);
> > -
> >  static const struct backlight_ops genericbl_ops = {
> >  	.options = BL_CORE_SUSPENDRESUME,
> >  	.get_brightness = genericbl_get_intensity,
> > --
> > 1.7.9.5
> >

