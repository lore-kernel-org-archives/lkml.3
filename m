Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaCKOSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:18:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56059 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaCKOSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:18:36 -0400
Date: Tue, 11 Mar 2014 14:18:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140311141824.GT28112@sirena.org.uk>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org>
 <1394531952-3905-3-git-send-email-geert@linux-m68k.org>
 <20140311104713.GN28112@sirena.org.uk>
 <CAMuHMdWoPWebnyUu2uGebbnzu68Lh4qsgzpu-otnwMmvaeY1hQ@mail.gmail.com>
 <20140311132652.GS28112@sirena.org.uk>
 <CAMuHMdVf_4TPf6YKuHLztrgFKWHTeoVi5agesO6tFU5h_56DOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rhuyk5QDIcoo2YDB"
Content-Disposition: inline
In-Reply-To: <CAMuHMdVf_4TPf6YKuHLztrgFKWHTeoVi5agesO6tFU5h_56DOA@mail.gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] spi: rspi: Add runtime PM support, using spi core
 auto_runtime_pm
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rhuyk5QDIcoo2YDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2014 at 02:35:15PM +0100, Geert Uytterhoeven wrote:
> On Tue, Mar 11, 2014 at 2:26 PM, Mark Brown <broonie@kernel.org> wrote:
> > On Tue, Mar 11, 2014 at 02:10:31PM +0100, Geert Uytterhoeven wrote:

> >> Can you please elaborate what should be fixed?

> >> If I disable CONFIG_PM_RUNTIME, the kernel prints:

> >>     Runtime PM disabled, clock forced on.

> >> and the clock is enabled all the time (verified by looking at the clock
> >> registers)?

> > That's very SH specific and doesn't apply in the general case (I would
> > not be surprised if future SH updates broke it...).

> Note that this is from drivers/base/power/clock_ops.c

> So what should I do instead?

Oh, is this manipulating the clock managed by the power domains?  If
that's the case don't worry about it, it's fine.  I'd thought it was
another clock.

--Rhuyk5QDIcoo2YDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHxssAAoJELSic+t+oim9CmwQAICD+Zs+I7xCa4Rxiywz7BOo
tYaF299QomFfNAaCtJZIE1GhsApJVaSQ/6CIvpvO/myJHXOu3hIvfXC8mROjkQcw
xQeLpN2qJhwp5fcqBYV0oHHEhaLCO5UpAmq2QbIx6iQZM3rTiJaSeJbrxoYEOAct
QdWQX2aKoSbOT+EGRz3vqRJSNROQ1RV7DwvprPTmxgwxB3UhVqRezHDz0ZmTU42q
glZpAQrzkddjTcagl8oipx+eq/KSgHLdroGyehbloHyb7MGU4Fb5wWIG+T+ZccWJ
KDAfSyMWTuiA8T8X+9ule5NUbEoVmF39rdiqoDiRZsfbSioQy/KDqT80vNvEJRGp
1EjBtMFOMe0/jnZ7Gr7Iqqq2XcSsjj+TgYJ2wfmP+5sTXR01/xH6dCIkFJv37R3g
zQbKuHAY1snzGySMxKDEYEdcrouQk+P6oz1m5jSFXz275b/J0pN9EMRmgwi4hVUV
ZrL3zgv4Wopm5XeXulTrMPoZfsTjT4KyqnlCZ+NI02qrhbRTZeAaEGgL1XEKxufR
2KpRAZiG8pWDSMDsiLdOf4OhZ0wI550DD8Lq0PwcqWsoIzJUVvsedyn7KTtleZSR
vVFxaiwd9s4eBkrpEtQ+mTnF1+mDwQyLM5dOuAaIJuDUQESAfraNLXgr/Md9pPu+
7uoa0Tu+CToEcvmPXGC+
=kgao
-----END PGP SIGNATURE-----

--Rhuyk5QDIcoo2YDB--
