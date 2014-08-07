Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaHGGNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:13:06 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:47574 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbaHGGNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:13:01 -0400
Date: Thu, 7 Aug 2014 08:12:57 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: caesar <caesar.wang@rock-chips.com>,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kumar Gala <galak@codeaurora.org>, Eddie Cai <cf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        Addy Ke <addy.ke@rock-chips.com>,
        =?utf-8?B?6ZmI5riQ6aOe?= <cjf@rock-chips.com>,
        han jiang <hj@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-pwm <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] pwm: rockchip: Added to support for RK3288 SoC
Message-ID: <20140807061255.GA17340@ulmo>
References: <1406197295-10604-1-git-send-email-caesar.wang@rock-chips.com>
 <1406197295-10604-3-git-send-email-caesar.wang@rock-chips.com>
 <CAD=FV=V4Kp-H3CcAKZPV1jBnYX+Ntwvxx6RB13TLxS5RRPHTWA@mail.gmail.com>
 <53E2D605.2000704@rock-chips.com>
 <CAD=FV=Xw8tz2keCUtO+qYUmnuv=+DPGZjY9-j_2XmAcP3Luzjg@mail.gmail.com>
 <53E2F11A.1040109@rock-chips.com>
 <CAD=FV=Wuj2_q+iW2EAj7w8TvgS=C2juSu+h_iG24NvPk4UqhKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <CAD=FV=Wuj2_q+iW2EAj7w8TvgS=C2juSu+h_iG24NvPk4UqhKQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 06, 2014 at 08:26:51PM -0700, Doug Anderson wrote:
> caesar,
>=20
> On Wed, Aug 6, 2014 at 8:23 PM, caesar <caesar.wang@rock-chips.com> wrote:
> >
> > =E5=9C=A8 2014=E5=B9=B408=E6=9C=8807=E6=97=A5 10:16, Doug Anderson =E5=
=86=99=E9=81=93:
> >
> >> Caesar,
> >>
> >> On Wed, Aug 6, 2014 at 6:27 PM, caesar <caesar.wang@rock-chips.com> wr=
ote:
> >>>
> >>> Doug,
> >>>
> >>> =E5=9C=A8 2014=E5=B9=B408=E6=9C=8807=E6=97=A5 06:46, Doug Anderson =
=E5=86=99=E9=81=93:
> >>>
> >>>> Caesar,
> >>>>
> >>>> On Thu, Jul 24, 2014 at 3:21 AM, Caesar Wang
> >>>> <caesar.wang@rock-chips.com>
> >>>> wrote:
> >>>>>
> >>>>> +static const struct rockchip_pwm_data pwm_data_v1 =3D {
> >>>>> +       .regs.duty =3D PWM_HRC,
> >>>>> +       .regs.period =3D PWM_LRC,
> >>>>> +       .regs.cntr =3D PWM_CNTR,
> >>>>> +       .regs.ctrl =3D PWM_CTRL,
> >>>>> +       .prescaler =3D PRESCALER,
> >>>>> +       .set_enable =3D rockchip_pwm_set_enable_v1,
> >>>>> +};
> >>>>> +
> >>>>> +static const struct rockchip_pwm_data pwm_data_v2 =3D {
> >>>>> +       .regs.duty =3D PWM_LRC,
> >>>>> +       .regs.period =3D PWM_HRC,
> >>>>> +       .regs.cntr =3D PWM_CNTR,
> >>>>> +       .regs.ctrl =3D PWM_CTRL,
> >>>>> +       .prescaler =3D PRESCALER-1,
> >>>>> +       .set_enable =3D rockchip_pwm_set_enable_v2,
> >>>>> +};
> >>>>> +
> >>>>> +static const struct rockchip_pwm_data pwm_data_vop =3D {
> >>>>> +       .regs.duty =3D PWM_LRC,
> >>>>> +       .regs.period =3D PWM_HRC,
> >>>>> +       .regs.cntr =3D PWM_CTRL,
> >>>>> +       .regs.ctrl =3D PWM_CNTR,
> >>>>
> >>>> Did you really mean to flip CTRL and CNTR here?  If so, that's super
> >>>> confusing and deserves a comment.  AKA, I think the above should not
> >>>> be:
> >>>>
> >>>>    +       .regs.cntr =3D PWM_CTRL,
> >>>>    +       .regs.ctrl =3D PWM_CNTR,
> >>>>
> >>>> ...but should be
> >>>>
> >>>>    +       .regs.cntr =3D PWM_CNTR,
> >>>>    +       .regs.ctrl =3D PWM_CTRL,
> >>>>
> >>>> If you didn't mean to flip CTRL and CNTR here, then just get rid of
> >>>> pwm_data_vop and refer to pwm_data_v2.  In fact, I'd suggest that you
> >>>> totally remove the "rockchip,vop-pwm" since there's nothing different
> >>>> between "rockchip,rk3288-pwm" and "rockchip,vop-pwm".
> >>>
> >>>
> >>> Sorry,I think it's no problem. the  "rockchip,rk3288-pwm" and
> >>> "rockchip,vop-pwm" are seperate PWM controllers.
> >>> They are just different registers address between CNTR and CTRL .
> >>
> >> OK, I looked up in the TRM.  Right, the CNTR and CTRL are flipped on
> >> the vop.  So I think that the only change you need is to add:
> >>
> >> #define PWM_VOP_CTRL  0x00
> >> #define PWM_VOP_CNTR  0x0c
> >>
> >> ...then use these new #defines for the vop structure.
> >>
> >>
> >> As you have the code written right now it's very confusing.  The new
> >> #defines will fix this.
> >>
> > yeah, I think they can be used in the same context.
> >
> > I will fix it in patch v5 if it is really need.
>=20
> I think you should fix this, but if Thierry doesn't think so then it's
> really his decision.

Frankly, I'm fine if these don't use symbolic names at all since only
the structure fields are used to refer to them now.

Thierry

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4xjnAAoJEN0jrNd/PrOhMo8QAI692uan9J+a5VBVT/jnMqeN
Pe1A4GbOGHyCQF5iu7i7b531bEEul4Wr4IQz7LdLpEJwweaTS3XuR5hcI/g6+Be+
bLq36pEvX371axXyAyQjq8JcP9vVchSzMy1gHKkP7XoYFNaXIl2t3qCtadb9HLwo
kOcgsNBVCmyfbhqHmUfOIv0Cbsz3thpUmGkRn1GCzRGnxBodkCc4g8IIDj5hsDh2
AJeVIBW4iFS7H5jK4YlPb9Rq1BPw8awW7veArBzkKBky/XV3yromtD/K/D0My49b
UPx8FNpSoKcnkiyHKTBU/e9KDnoYJ/yxulhc+jjC0FXl2DsczowRY1D/cI8repuq
QBPhq67mA/OxOC34cRoKZ+9oeLCzsyRvMEFadowp98i/Ddiaqlemn59rgHt3nBkO
pbNth6ZRAHwHBMblbq4O5Uem1ZnWdje1K1/E4+XQdq1LZCCNPI6sFKxm0QKMBpSA
747OhBaDfF/lCrAT9bBlheFneWKZ8DEEPJT3XY+ZktL28iPVl6hACJMdB2/RcvU7
yITlJZsY+IABRVTpHJZEi24nGDUSUKSghx9mbbsMq9n/lbCh+Nx6fjPkUtm8ijW/
DlD2gm8Yc9Vn7m37rJ7tz9ZlKuVIfmzTLwlNyXXHOIG9hVEvNB++CC3a7DNQsOty
X3U8xoUo01T9tCJJFoMm
=wGPw
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
