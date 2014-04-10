Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965841AbaDJJv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:51:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40036 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965601AbaDJJvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:51:46 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-9d-534669b18b3c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Alexandre Courbot'" <gnurou@gmail.com>,
        "'Alexandre Courbot'" <acourbot@nvidia.com>
Cc: "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Bryan Wu'" <cooloney@gmail.com>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-pwm@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1393480414-19473-1-git-send-email-acourbot@nvidia.com>
 <1393480414-19473-2-git-send-email-acourbot@nvidia.com>
 <CAAVeFu+XUzZ7ozMOcp6A-gZJ9o8DZFrdh1j4LvCQtoTcu=PP1g@mail.gmail.com>
In-reply-to: <CAAVeFu+XUzZ7ozMOcp6A-gZJ9o8DZFrdh1j4LvCQtoTcu=PP1g@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: SAMSUNG: remove gpio flags in dev-backlight
Date: Thu, 10 Apr 2014 18:51:45 +0900
Message-id: <000701cf54a2$7c1379c0$743a6d40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9Uc9gRSh4xxKlJQ3G7k3jmM+VzoAALUegw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zI92NmW7BBn82SFh8f3iK1WLSugNM
	Fkd3TmSyOPfqEYvF5YWXWC16F1xls9g8/w+jxeVdc9gs7t5dxWjxc9c8Fgcuj7+rXjB77Jx1
	l92jt/kdm0ffllWMHp83yQWwRnHZpKTmZJalFunbJXBltD2TK7gmWDFzuX0D4y/eLkZODgkB
	E4kNHb9YIWwxiQv31rN1MXJxCAksY5RYs+UiI0zRrN4VzBCJRYwSradfQ1X9ZpT4seQ1E0gV
	m4CaxJcvh9lBbBGBcIkPa16BFTEL7GKSuHlhBiNExxFGiZ7zc5lBqjgFgiW2dd0Fs4UFPCWW
	T1wFto9FQFVi9+ImsKN4BWwlOt5dhLIFJX5MvscCYjMLqEtMmreIGcKWl9i85i2QzQF0q7rE
	o7+6EEcYSTz+u4odokREYt+Ld2A3SAg0ckhMWPifBWKXgMS3yYdYIHplJTYdYIZ4WVLi4Iob
	LBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQ6J64g/H+
	AetDjMlA6ycyS4km5wOTQ15JvKGxmZGFqYmpsZG5pRlpwkrivOmPkoKEBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MObd4Je/7lXdHh7reubXtOmfEo+EiPPeWbBiJbPexATr/DPn+DK1y9VC
	Qh6vCU/zF0nLPGhcpKoeHi3H/zDh9xdxS8WZz82nS0orFCXP+1XGHB138Jez2Ln1bOYtHXO+
	2f3/8ePK5a2H3ObmsSh8un+Sbf619kOnDOOlOe++s3K/s1f7WOv8K0osxRmJhlrMRcWJAIO1
	nnQEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jAd2NmW7BBlc3Clt8f3iK1WLSugNM
	Fkd3TmSyOPfqEYvF5YWXWC16F1xls9g8/w+jxeVdc9gs7t5dxWjxc9c8Fgcuj7+rXjB77Jx1
	l92jt/kdm0ffllWMHp83yQWwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgr
	KeQl5qbaKrn4BOi6ZeYAnaWkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxj
	zGh7JldwTbBi5nL7BsZfvF2MnBwSAiYSs3pXMEPYYhIX7q1n62Lk4hASWMQo0Xr6NZTzm1Hi
	x5LXTCBVbAJqEl++HGYHsUUEwiU+rHkFVsQssItJ4uaFGYwQHUcYJXrOzwWbyykQLLGt6y6Y
	LSzgKbF84ipGEJtFQFVi9+ImVhCbV8BWouPdRShbUOLH5HssIDazgLrEpHmLmCFseYnNa94C
	2RxAt6pLPPqrC3GEkcTjv6vYIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcU
	J6XnGukVJ+YWl+al6yXn525iBKeOZ9I7GFc1WBxiFOBgVOLhPbDMNViINbGsuDL3EKMEB7OS
	CO+1YLdgId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4HprW8knhDYxMzI0sjMwsjE3Nz0oSV
	xHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBs8LqT5n7/ZLBnmf0xm0USuhcZIh/uCGcXnfar
	PvHM1efbl1hGXV65Si6SWTB1tvBMVbY437JX9YtPcTn4O21Tqdxx5eiUxzkbBB6lL/ydK+My
	g2nd5cbjxn95FSa+i/tvxDK5J3WxUlXCFofP/V9vCKX86pjh7RhvKXDKuZ35rqqG096XtvFK
	LMUZiYZazEXFiQDgGZQ5YQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 10, 2014 1:17 PM, Alexandre Courbot wrote:
> 
> Ping, can I have the Samsung folks review and ,aybe even merge this
> patch? enable_gpio_flags is never used in any code, is replaced by
> gpiod, and we would like to remove it altogether from pwm_bl. Thanks!

OK, I see. It looks good.

As far as I know, 'enable_gpio_flags' has not been being used
for Samsung platform. So, there will be no side effect,
if 'enable_gpio_flags' is removed from 'arch/arm/plat-samsung'
directory.

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
> Alex.
> 
> On Thu, Feb 27, 2014 at 2:53 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> > The pwm-backlight driver is moving to use the gpiod interface,
> > which has its own mapping mechanism for platform data GPIOs.
> > These mappings carry GPIO properties like active low so they don't have
> > to be explicitly handled by GPIO consumers.
> >
> > Because of this change, the enable_gpio_flags member of
> > platform_pwm_backlight_data is going away. dev-backlight was passing
> > this member, but had no user making use of it, so it can safely be
> > removed. Further GPIOs used by pwm-backlight are expected to be
> > defined using the mechanisms provided by the gpiod API.
> >
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > ---
> >  arch/arm/plat-samsung/dev-backlight.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/arch/arm/plat-samsung/dev-backlight.c b/arch/arm/plat-samsung/dev-backlight.c
> > index be4ad0b21c08..2157c5b539e6 100644
> > --- a/arch/arm/plat-samsung/dev-backlight.c
> > +++ b/arch/arm/plat-samsung/dev-backlight.c
> > @@ -124,8 +124,6 @@ void __init samsung_bl_set(struct samsung_bl_gpio_info *gpio_info,
> >                 samsung_bl_data->pwm_period_ns = bl_data->pwm_period_ns;
> >         if (bl_data->enable_gpio >= 0)
> >                 samsung_bl_data->enable_gpio = bl_data->enable_gpio;
> > -       if (bl_data->enable_gpio_flags)
> > -               samsung_bl_data->enable_gpio_flags = bl_data->enable_gpio_flags;
> >         if (bl_data->init)
> >                 samsung_bl_data->init = bl_data->init;
> >         if (bl_data->notify)
> > --
> > 1.9.0

