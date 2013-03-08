Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab3CHCP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:15:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44683 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029Ab3CHCP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:15:58 -0500
Date: Fri, 8 Mar 2013 10:15:29 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Afzal Mohammed <afzal.mohd.ma@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: Question about fixed-clock
Message-ID: <20130308021527.GA28481@opensource.wolfsonmicro.com>
References: <20130307184240.GA3327@afzal-ThinkPad-R50e>
 <5139155F.5050407@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <5139155F.5050407@gmail.com>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 07, 2013 at 11:31:59PM +0100, Daniel Mack wrote:
> On 07.03.2013 19:42, Afzal Mohammed wrote:

> > I feel that for a platform having it's clock tree in DT, of_clk_init
> > would take care of it, but if clock tree data is not in DT, clock
> > tree would have to be extended in a non-DT way.

> Hmm, I don't follow. So for generic OMAP board in general which does
> *not* have its SoC clocks in DT, the question is who's in charge of
> registering out-of-SoC fixed clocks that are defined in DT.

> Note that the clock I'm dealing with here is _outside_ of the SoC, and I
> just need to have it in DT, so it can feed another clock chip's input pin.

> Grep'ing through arch/arm, it seems that the imx arch does the same
> thing my patch does, but I could also imagine that it should be done
> somewhere from the DT core. I copied Grant, Rob and Mark for more comments.

Wouldn't this just be set up by the DT in the same way that other
off-SoC hardware is?

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJROUm0AAoJELSic+t+oim9ED8QAJbU6CNQ+zIqJSchXAFRRLHQ
7jszfHoAlzhzRW8YtSPlCEodyU7/NPCK09+J5PEypwPX/FAUl2Tju/RCQPtHycVK
vXHIZC6uYmMlgPT9cQmXVouL0FWuv/fGj18kRAiLx+BZdqqPRObJ9SH9271n5NKc
GOHLsYS0TKvitF0EBnt3SbOvnEOlr6P0bcISwT2BaPn4wvs5/qGI26vN/F/dyzGn
znecHtv6ZAMfg2Ho0thMtEM2WbpENRSxwTo2ESXGqc49+bnMd9q68qccTXHY1p6L
zJEm2R1jvDAkCYvAr9i+AwTs6ctArPYEny07Wi2wpCh33rTp9IAeY+KRkh5hV6f9
HT3z5K0foMTgzMkoFBel3a+1AcgBhx3uZ7H3jVdQcslc8io0PALGGS/XwOlh0f7h
XlciJjTtoCYx2n1EdmTVRtt2BE6LvSWNLZSbKoygR8kGWrfygrSBNXUuDG00A/9k
2TTnTs34w9ckeCausg8sOYiv26jL2Cs+EbEjad+3g++dbv9BjdoSFVO24KcJA48g
SXqxZV3gOanvOBdBX7az+dgm8YybsJ7c/7m11/CHZLp44QBkoqMrEDRVmexSOiu0
ELOQ/rcKHdoVdXlzMq9Z4H3cpSn7M6EGmGJVeW/t+vIDkZ+e6sJlFvGaBnfIDbtU
szAxJ0of9iCtv7Ci6zgj
=wvfu
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
