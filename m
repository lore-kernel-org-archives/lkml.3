Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbaHHJrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:47:02 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47854 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaHHJq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:46:59 -0400
Date: Fri, 8 Aug 2014 11:46:55 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: Re: [PATCH v2 06/11] pwm: sti: Add new driver for ST's PWM IP
Message-ID: <20140808094655.GC15852@ulmo>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
 <1405348412-7352-7-git-send-email-lee.jones@linaro.org>
 <20140807142344.GA11095@ulmo.nvidia.com>
 <20140808073802.GC21618@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KDt/GgjP6HVcx58l"
Content-Disposition: inline
In-Reply-To: <20140808073802.GC21618@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 08:38:02AM +0100, Lee Jones wrote:
> On Thu, 07 Aug 2014, Thierry Reding wrote:
> > On Mon, Jul 14, 2014 at 03:33:27PM +0100, Lee Jones wrote:
> > [...]
> > > +static int sti_pwm_probe(struct platform_device *pdev)
> > > +{
> > [...]
> > > +	pc->clk =3D of_clk_get_by_name(np, "pwm");
> >=20
> > This didn't compile because the np variable isn't declared. It was easy
> > to fix up, so I did, but please be more careful next time that the
> > patches you submit at least compile (preferably without sparse warnings
> > of which I also fixed up a couple).
>=20
> That's annoying, I thought I did build test the final changes.
> However, there's a mistake in the Makefile meaning that it wasn't
> building with no warning/error messages - it actually wasn't building
> at all!  Sorry about that Thierry.
>=20
> I guess if you can build the driver, you've already fixed that?

Yes, it should be all taken care of in the PWM for-next branch.

Thierry

--KDt/GgjP6HVcx58l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT5JyPAAoJEN0jrNd/PrOhiYsQALs5+YuEzMr3gzPXaVvgP5vj
3Nm7+3jH8UgNUqQMbw3gJjitkn50nP4Uowe6+xKQs16cSkM5aGHY2I5nnzVH9ftT
hbisisxFb6VaOUWGAfFnuKzIlG/EAPu/Nlh/T5ED2DyDwB3Blkqo+ztfsfhzKOHe
e04uywaHiEA1MKnBxyxplgjJPm4uK18XsDf0SRxZCait5DCTRTe7OsaRv5a/f7vv
ui6c1fc5Hmha8yspQFI5nTCEl6gcZMMq10aTso3ShMrufvQ9fT685+GrgA4QfLf0
V+U6gl5n57OBhS1veXaF5eoneq7OsKIUjyGXtlLN5I0aeOSaQ0ayBe/NYJYP6P5t
zOuH7dhqPcvOlj2behCAkJLMiecLBpZVLtIZZ0alGIcc1D3DToYDYbZTP3Nzvd7A
52l1WNcwnXcTWfd2uLULj7qZSMiKzzSuGKJMgEq8JnkDnK9uzPDiIQF/L9wBdT3z
bLIOEgyGpfUfWSgxXKSTUv/qWtoUWei5CrOq5gmFAPI/gvG5iB/SQ40y0eJ7PnSw
7bDPLEbZf91hOxHXtUCLhR0RUrSQff7u5s6QAfrSO1tf3ABVFDoTVsTqRbwVLk4f
TfVSDeyfAydTnM+bOgabER3Wc46ho9E4GPnrugYF1527sLWZMFHousKTS0JYVNCT
Qx2gqPa6LplU0ViRocgM
=rVJs
-----END PGP SIGNATURE-----

--KDt/GgjP6HVcx58l--
