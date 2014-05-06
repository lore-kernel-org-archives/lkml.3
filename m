Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbaEFPTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:19:30 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64430 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaEFPT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:19:28 -0400
Date: Tue, 6 May 2014 17:17:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Alexandre Courbot <acourbot@nvidia.com>, Bryan Wu <cooloney@gmail.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: SAMSUNG: remove gpio flags in dev-backlight
Message-ID: <20140506151736.GA7176@ulmo>
References: <1393480414-19473-1-git-send-email-acourbot@nvidia.com>
 <1393480414-19473-2-git-send-email-acourbot@nvidia.com>
 <CAAVeFu+XUzZ7ozMOcp6A-gZJ9o8DZFrdh1j4LvCQtoTcu=PP1g@mail.gmail.com>
 <000701cf54a2$7c1379c0$743a6d40$%han@samsung.com>
 <CAAVeFuKJnSk2XSsMZZKMfyabzJ5CYdqWdE91H5uHiYFC1r6HxA@mail.gmail.com>
 <CAAVeFuKeT9+m_yFc8ihfc_p5W--dCm0-eO+ccjv99WOwurAirQ@mail.gmail.com>
 <0fa001cf68e7$e7c4c440$b74e4cc0$@samsung.com>
 <CAAVeFuJYrez9Ugqerys9Un0jRHnwMcwZ9BxnswbF=2m_LpMLSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <CAAVeFuJYrez9Ugqerys9Un0jRHnwMcwZ9BxnswbF=2m_LpMLSw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2014 at 11:33:00PM +0900, Alexandre Courbot wrote:
> On Tue, May 6, 2014 at 1:59 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > Alexandre Courbot wrote:
> >>
> >> On Thu, Apr 10, 2014 at 11:14 PM, Alexandre Courbot <gnurou@gmail.com>
> >> wrote:
> >> > On Thu, Apr 10, 2014 at 6:51 PM, Jingoo Han <jg1.han@samsung.com> wr=
ote:
> >> >> On Thursday, April 10, 2014 1:17 PM, Alexandre Courbot wrote:
> >> >>>
> >> >>> Ping, can I have the Samsung folks review and ,aybe even merge this
> >> >>> patch? enable_gpio_flags is never used in any code, is replaced by
> >> >>> gpiod, and we would like to remove it altogether from pwm_bl. Than=
ks!
> >> >>
> >> >> OK, I see. It looks good.
> >> >>
> >> >> As far as I know, 'enable_gpio_flags' has not been being used
> >> >> for Samsung platform. So, there will be no side effect,
> >> >> if 'enable_gpio_flags' is removed from 'arch/arm/plat-samsung'
> >> >> directory.
> >> >>
> >> >> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
> >> >
> >> > Great, thanks. Ben, Kukjin, could we have your Acked-by?
> >> >
> >> > Thierry, if the Samsung maintainers are ok with it, and 2/2 of this
> >> > series is also ok for you (you merged the same for simple-panel
> >> > already), can you take both into your tree?
> >>
> >> Last call - could we have a Acked-by from Ben or Kukjin and merge this
> >> through Thierry's tree? Otherwise I will just have to drop this
> >> series, which would be sad.
> >
> > Very sorry for late response. I missed... :(
> >
> > Looks good to me, so please go ahead with my ack.
>=20
> Thanks Kukjin!
>=20
> Thierry, do you want me to rebase and resend these (now old) patches?
> I haven't heard anything from you about them yet.

No, that's fine. I can handle them.

Thanks,
Thierry

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTaP0QAAoJEN0jrNd/PrOhsKUP/jCCjiohxWsy4f0AFmMJMkXf
GlQ9G/ry54mNbJXbuEx+EqwZBcjyxUAF2+7Ytzu59tujJsxrd7fuZRRaf+3xm2wR
VulZnX3Uvy+TtBs0Zgwl25L1uTWqnz5TnIvd9/tPWWJ7qQJ1X7zdmYmxWw2D8pPD
K24yA6+niZv9Re7c6FrbgE15qu93TzzI5iHudJi4/2ixAvqagPzYlplaW2lZ8cr3
eEpGDeInel3nXer75Yc2Rz0yBasctIzveFBuO6NLyWcrxnPBM5g6rOFuMLdq5UpS
+xfRnozfraIwiKQBoAuovsW0m7s9a7VbZJm7zPQg1rWGT0HhnkVqzWXtaMdWHEyc
ZdnbS4g+VxXMpWjgMMDk7xdQ96vPrj5Ss0bWQj4dWgD/89kp/GZ7rrGUSR4jkXmt
aDiU4cFyKvKBr0HTmkf8CFCnx5ymJuYyFNmJsH+zA0xyEMUGyDZlZrvb93eqHetT
vj4+G1TBSmTQsVJDqXgDsBTuB08UxpxnGjbwOBEADSk0sCXodetHjIFhysatze5E
U13xv3kbGJZB/uIrD4gnGcOMJQ2zO3Vvi7IxtMps5kJqu0ti9S+4St0ME9Ii6n/D
SpUuCiYhiN5TxgQ5z8rJxOKtFW0pvs+4U+KtoZo5rVOVESOTAnxbjGtk0eD8l5EF
xpD1HFZ5hzlPmJjKsvEO
=Aaq5
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
