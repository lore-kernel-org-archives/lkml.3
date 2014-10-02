Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaJBMy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:54:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61019 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJBMyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:54:54 -0400
Date: Thu, 2 Oct 2014 14:54:51 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Move AHB Kconfig to drivers/amba
Message-ID: <20141002125450.GA9916@ulmo>
References: <1406643934-16301-1-git-send-email-thierry.reding@gmail.com>
 <53D7C9EE.60503@wwwdotorg.org>
 <53FB7288.9050002@wwwdotorg.org>
 <5408BF77.1020007@wwwdotorg.org>
 <20141002105103.GA13906@ulmo>
 <20141002110805.GT5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <20141002110805.GT5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 02, 2014 at 12:08:05PM +0100, Russell King - ARM Linux wrote:
> On Thu, Oct 02, 2014 at 12:51:04PM +0200, Thierry Reding wrote:
> > On Thu, Sep 04, 2014 at 01:37:27PM -0600, Stephen Warren wrote:
> > > On 08/25/2014 11:29 AM, Stephen Warren wrote:
> > > >On 07/29/2014 10:21 AM, Stephen Warren wrote:
> > > >>On 07/29/2014 08:25 AM, Thierry Reding wrote:
> > > >>>From: Thierry Reding <treding@nvidia.com>
> > > >>>
> > > >>>This will allow the Kconfig option to be shared among 32-bit and 6=
4-bit
> > > >>>ARM.
> > > >>
> > > >>This seems fine to me. I'd expect to apply it for 3.18, provided I =
get
> > > >>an ack from Russell as drivers/amba maintainer (hence CCing him wit=
hout
> > > >>trimming the quote).
> > > >
> > > >Russell,
> > > >
> > > >Are you OK with this patch? If so, if you could ack it so I can apply
> > > >it, that would be great.
> > >=20
> > > Russell?
> >=20
> > Russell,
> >=20
> > Can I have your Acked-by on this or would you prefer it to be submitted
> > to the patch tracker? Would the patch tracker be the correct place also
> > for non-ARM core patches?
>=20
> I just had to go digging for the original patch, as I've been missing
> this.
>=20
> I think this is fine, though if we're going to have drivers/amba/Kconfig,
> we should also move the ARM_AMBA Kconfig option there too.  Note that it
> currently appears in both arch/arm/Kconfig and arch/arm64/Kconfig.

Okay, let me turn that into a prequel patch for this one.

Thierry

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJULUsaAAoJEN0jrNd/PrOhCjMQAK9374uM2gZO3NiDGcxxvO1R
GkUVc49zwu7NfMWQEOxjrNwFjOXkLuri4mQENJ6ecWYCp60pn0loEGaHvdcLyxW6
R7qLtu2my6LPOjmuPZTS8czse3eJf8Y+D+hk8axhOB0m2/t9NuCr5Mm/Ecn+6pm4
pujhfnE5LahzUkp+AYgAcvfnYbCyePT/NrBs3NA/pZR4Dn5gkP7jzYK4Ehd8t9Sk
TxjrdRIR4odtibY8oNOwrKNQ8ubod1mGGMsawTcVgXGk9301fNIHQI0kYfMrEgug
IEUUZH8njJJ0W8f4606mcGN2HvlFc70sBV5vUIZ9PQ81dNE36uskqh3RRChgbjXp
E5GitQqt4GXPRBZY1vAdgFWgF3heyunkH5Ukd+6A+J9C+YxlT0k+mG35yrIAZHq1
Kwy9MG1oZMUMTePpXLOqv7oXMCWQcsRU3k43EZQ6pSGp0bxmOy8oDFGl3fMUW9t4
plc8dIOfntqfRIetHB4LsqJqC59IJdSgz4iWZZvGGFkbhITFKZaCvLKEuPWwY9w5
6Y9y4jn/lSGvj0ryZEBvsr5IuJDY1bbwDuGVEQ4eSiQn0yDE+3TBm8A7HO4MkGmd
zrGHP9VEQH5Hu6WmJtZuQSDrf5vnLQA/jQFhjSZojCILUtMaHNKGgYyEblLjVDrq
kOGQHxIXgqBLNLfCPDTH
=XKlE
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
