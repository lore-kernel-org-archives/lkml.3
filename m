Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaHUGkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:40:33 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:65053 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaHUGkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:40:31 -0400
Date: Thu, 21 Aug 2014 08:40:27 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-pwm <linux-pwm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        hpa@zytor.com
Subject: Re: [PATCH v3 2/4] pwm: rockchip: Allow polarity invert on rk3288
Message-ID: <20140821064026.GC4486@ulmo>
References: <1408464476-28316-1-git-send-email-dianders@chromium.org>
 <1408464476-28316-3-git-send-email-dianders@chromium.org>
 <20140820100447.GG15414@ulmo>
 <CAD=FV=U9gOiY=4s7WmAQcm0n9s67nWdqQ3A0L2B7Dg83dNotjQ@mail.gmail.com>
 <387c82a0-efeb-431d-b8a5-200f24bc47ff@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Content-Disposition: inline
In-Reply-To: <387c82a0-efeb-431d-b8a5-200f24bc47ff@email.android.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 02:29:17PM -0500, Dmitry Torokhov wrote:
> On August 20, 2014 1:54:11 PM CDT, Doug Anderson <dianders@chromium.org> =
wrote:
> >On Wed, Aug 20, 2014 at 3:04 AM, Thierry Reding
> ><thierry.reding@gmail.com> wrote:
> >> On Tue, Aug 19, 2014 at 09:07:54AM -0700, Doug Anderson wrote:
> >>> The rk3288 has the ability to invert=20
> >>> +     struct rockchip_pwm_chip *pc =3D to_rockchip_pwm_chip(chip);
> >>> +
> >>> +     if (!pc->data->has_invert)
> >>> +             return -ENOSYS;
> >>> +
>=20
> At the kernel summit hpa also mentioned that ENOSYS should only be
> used for missing syscalls. Not sure what error code would suit better
> here though...

I'd be interested in the rationale why ENOSYS shouldn't be used within
the kernel. As long as it doesn't leak to userspace where it could
possibly confuse applications I don't see any harm in using it.

Thierry

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9ZRaAAoJEN0jrNd/PrOh/IcP/1CZ4mxFlhF2tnA60jGftEDr
wvA6pH76QehJcZ78TNPlmXBHTSMnggnfWDk3hPnHWcfaSwQv4ad1s+4zjdslTGcD
jcJbgjjEIPCxU5O/JkXQeyUQ3Wv8Dqw4m12vNvQ4JUUCRdaG7bM+KbWnyjDTHxTs
HxojmqdzFXR1pKd2obx6tzladGlLdvJ60Outp3z/01EhRqQvTPnI2KmG8y73eTt7
dEfJrU0NvUKC3Xy74u+xXHQPlR0zAuSvaG5ur6AYy0LQNinEhvLY63BKgds3tBJx
KlVThiYgHgooHcmil2Pk7vgIubTjrgb1EB1qk47hDYmdCuZjrzOVoGPZheK4Capj
HFQ+6/HXSdm9SOL1bNm5bBbwzkNoNwENLBRH6xwaDNe925bKnQWHPGkQn4tYqPNQ
NO/je2vDMlXXRsKL6KokyzeVP0pVsgcBQPAdkOYhOj9LIQd3UIaziplSsKQnS8dt
w1fw3RHIGFxXO1vGP6shNgbvf4lJEjmphK8G+j/bpe7Fl5p2WSLDgBXNn7fx0gKa
y/LS8D92qL6lw4Gda+gik5wkRZl1gLCBmpUTjGJIBCTKzzjOViS59HAI4KeVJkQr
X3FOrcKREA/a+Gl3TtM6MHvXOr9X+kPprkNx5lX85GqpEnN4LlH7wm4aDW2X0i58
kranc3xsm5/7TTQYP+1z
=J8A6
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
