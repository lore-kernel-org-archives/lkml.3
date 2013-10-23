Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3JWJMC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:12:02 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:45825 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3JWJL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:11:59 -0400
Date: Wed, 23 Oct 2013 11:09:26 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Zhang <nvmarkzhang@gmail.com>
Cc: rpurdie@rpsys.net, jg1.han@samsung.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com, linux-pwm@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to set fops in "struct platform_pwm_backlight_data"?
Message-ID: <20131023090925.GC11954@ulmo.nvidia.com>
References: <525F8895.5010806@gmail.com>
 <20131017071445.GA2502@ulmo.nvidia.com>
 <5260BD8C.7000200@gmail.com>
 <20131022072443.GB8681@ulmo.nvidia.com>
 <52663D6D.5000806@gmail.com>
 <20131022124905.GA24255@ulmo.nvidia.com>
 <52673178.8070805@gmail.com>
 <20131023080002.GB7404@ulmo.nvidia.com>
 <52678D99.8090003@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <52678D99.8090003@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2013 at 04:49:29PM +0800, Mark Zhang wrote:
> On 10/23/2013 04:00 PM, Thierry Reding wrote:
> > On Wed, Oct 23, 2013 at 10:16:24AM +0800, Mark Zhang wrote:
> >> On 10/22/2013 08:49 PM, Thierry Reding wrote:
> >>> On Tue, Oct 22, 2013 at 04:55:09PM +0800, Mark Zhang wrote:
> >>>> On 10/22/2013 03:24 PM, Thierry Reding wrote:
> >>>>> On Fri, Oct 18, 2013 at 12:48:12PM +0800, Mark Zhang wrote:
> >>>> [...]
> >>>>>>>
> >>>>>>
> >>>>>> Okay, I just want to set the "notify" function pointer in "struct
> >>>>>> platform_pwm_backlight_data", because I want to tune the brightness
> >>>>>> value before the pwm-bl sets the brightness to hardware. I don't k=
now
> >>>>>> how to do that, unless we define the platform data explicitly.
> >>>>>
> >>>>> Okay, my question should have been what you need the functions for =
and
> >>>>> why you think you need them.
> >>>>>
> >>>>
> >>>> If I understanding you correctly, I suppose I've said that: "because=
 I
> >>>> want to tune the brightness value before the pwm-bl sets the brightn=
ess
> >>>> to hardware".
> >>>
> >>> Why do you want to tune the brightness value? What are you trying to
> >>> achieve?
> >>>
> >>
> >> Oh, Tegra has a feature named PRISM(aka SmartDimmer). It changes the
> >> color value to make the display looks bright so that we can reduce the
> >> backlight brightness to save power. So everytime PRISM is triggered, we
> >> call "backlight_update_status", then in the "notify" callback, we chan=
ge
> >> the brightness value which pwm-bl provides by considering the PRISM
> >> compensations.
> >=20
> > If you automatically call backlight_update_status() everytime PRISM
> > gives you new data, can't you just pass the correct value in in the
> > first place so that you don't have to tweak it in the .notify()
> > callback?
>=20
> OK, how to do that? -- "pass the correct value in in the first place"?

Well, if you call backlight_update_status(), then you can pass in a
brightness value, right? You usually do that by setting the backlight's
props.brightness field.

So when PRISM gives you new data, you could just read out the current
brightness, compute the new one based on the current one and the PRISM
data, set the props.brightness field to that value and then call
backlight_update_status().

Thierry

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZ5JFAAoJEN0jrNd/PrOhsQkP+wUwgz6WMeVOnudgw/BhmNim
p1sKqqZfYpiWjp3ZR3ccQkpr/spUvMwvoe+92hV6tBQLwZKVkvjXN7eSd7l0RW3Q
WshjN8j8zz3X/qU391vIs8oc7txy8SBSh93XlDup3VBn4fXRyCObUDOLtJzdOp9x
dkJO3vLaQ+reZ3BW3Ql0rh5RWI0VqQU4H6llDroXBPxC0Ka4/dPtIk+Hz2RPwoe+
enjWucW82KyZSl9UMVGQmqZjlO82YVXJb+5M4tTbgxJGsVRjPrknvCFwhIOtgKua
ykPXvQzmsRekTzbf/xLqNxDfejRXP7VOtp5aAJq53t8z89yC8F45MRIVZAu+z2K8
pc70xQHolkNqnnxcotWTb7VoYjhUUujNPyb1kf957cE0Lm4SEZwAIaY4DR46rzd/
HkBcWUunq1TA3L9QrCqOw6er0aqCjLD+ej8v/+c0CywMD6s8U+bmwA/El/GDrQV4
kwNjUxdHySP4Ofs7DTKeq2A+dZX1bAdsEVgwcN4xs3gOWvVrtYdwE7QUN+N1VKbz
cce6012OrmqIqMAUY+eM02dIo4w0ZXxWMsUhsMH9KitgSFcxF+sqwlXcBQHB917Y
CRhIDhQ5vxDPHG3CJsXgFLJR6sAtxJtqEn5x6A49nAfHLnvyUcRzhEvjVYoo6rME
dg5fz56eAA8cgj0Lawyv
=RKsT
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
