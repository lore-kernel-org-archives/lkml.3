Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3CXVNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 17:13:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33192 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161Ab3CXVNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 17:13:41 -0400
Date: Sun, 24 Mar 2013 21:13:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ian Lartey <ian@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        mturquette@linaro.org, linus.walleij@linaro.org, cooloney@gmail.com,
        rpurdie@rpsys.net, akpm@linux-foundation.org, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com
Subject: Re: [PATCH v10 0/12] Palmas updates
Message-ID: <20130324211336.GA18316@opensource.wolfsonmicro.com>
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
 <20130323060455.78a4c90c3f1e028434818fd1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20130323060455.78a4c90c3f1e028434818fd1@canb.auug.org.au>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 23, 2013 at 06:04:55AM +1100, Stephen Rothwell wrote:
> On Fri, 22 Mar 2013 14:55:10 +0000 Ian Lartey <ian@slimlogic.co.uk> wrote:

> > Patches based on linux-next-20130319

> I can't really comment on the patch set except to say that you should not
> base on linux-next, you should base on the tree to which you expect the
> patch set to be applied.

It's fairly common to suggest to people working over lots of subsystems
like this that they use -next since for most subsystems it contains the
trees that should be submitted against and it's much more efficient.
This works OK most of the time when people are posting patches as
opposed to pull requests, though obviously cross tree issues do happen
=66rom time to time.

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRT2xmAAoJELSic+t+oim9sQ8P/3zX1xNz3uTlq3HlnhSX79xf
7Iw6wgZ+1SILWpR1+FEfkCNjUuf9C4raa5DBVJM6VOqbldQENviWMrmojhi5y+Ts
2bCCuB/1+55C0W1WhNaAnmCtL6Yrg7RVlUr3zMLeETOWlmGc+TeNywzJMZdWCurs
Z+DOMaZRG5AehOc1XZ0lZrGlP9QVSXTjKpGPVT65vS8Ttj9aNa7+U0X4tCVDRxsk
ptN61dBPWXtx1PSaEiJ6IMgf8Gx7IBEtJFt1i3VgCGlFqgKrEq9oshsn1L4VwjG+
mWiRVf5lpDhfmxUO8yFq2IbF/nVTsAx4kp45J9IbdCTjwVh5AuF8/VIDDpTIlVdO
ibotoXoeEF4qZe/UZSwkUhVq3Pv2/z1oSrG++N0Z1KAbrnUjCLymG50zfYY8cJXP
g1Lu6iv89emD6nMdaA/mOCsFzX+eeuBuY+Cx5j8N+EbergNjxppx4JRnplXvbNOJ
7I/+VX1flt+pzwz6tpwwzvlSEA2yy1E5cPG9ER3tT8pwgioeR7bq6fd6V9mkiVc/
oPjgfQ/Wll4V78nSp1yQfvKoxqW/GOczrTSv4KcJFWU+X+xMf3NEUslHYZ0xjqHv
yNlXBx0WCqnNxCf1v8X68eMqm55YV7VRkddVR7pLV5Wdo0O/wNBc1IqV4cueU1Ze
zKqVHVWL6GlFwJbMJS8l
=Zv8k
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
