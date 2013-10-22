Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3JVKsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:48:52 -0400
Received: from drsnuggles.stderr.nl ([94.142.244.14]:41059 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3JVKst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:48:49 -0400
Date: Tue, 22 Oct 2013 12:48:29 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Matt Porter <matt.porter@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Does PHY UTMI data width belong to DWC2 or PHY binding?
Message-ID: <20131022104829.GF15425@login.drsnuggles.stderr.nl>
Mail-Followup-To: Matthijs Kooijman <matthijs@stdin.nl>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Matt Porter <matt.porter@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@nvidia.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Paul Zimmerman <paulz@synopsys.com>,
	Devicetree List <devicetree@vger.kernel.org>,
	Linux USB List <linux-usb@vger.kernel.org>,
	Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20131018141221.GH2721@beef>
 <5264F37E.9060307@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L2Brqb15TUChFOBK"
Content-Disposition: inline
In-Reply-To: <5264F37E.9060307@ti.com>
X-PGP-Fingerprint: 7F6A 9F44 2820 18E2 18DE  24AA CF49 D0E6 8A2F AFBC
X-PGP-Key: http://www.stderr.nl/static/files/gpg_pubkey.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spamchecked on "mail.drsnuggles.stderr.nl"
	pts  rule name              description
	---- ---------------------- -------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L2Brqb15TUChFOBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kishon,

On Mon, Oct 21, 2013 at 02:57:26PM +0530, Kishon Vijay Abraham I wrote:
> I think it makes sense to keep the data width property in the dwc2 node itself.
> I mean it describes how the dwc2 IP is configured in that particular SoC (given
> that it can be either <8> or <16>).
If I'm reading the RT3052 datasheet correctly (GHWCFG4 register), the IP
can be configured for 8, 16 or 8 _and_ 16. In the latter case, the "8
and 16 supported" would make sense as a property of dwc2 (though this
value should be autodetectable through GHWCFG4), while the actual 8 or
16 supported by the PHY would make sense as property of a phy.

Note sure if this is really useful in practice as well, or if just
setting the actual width to use on dwc2 makes more sense...

Gr.

Matthijs

--L2Brqb15TUChFOBK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAlJmV/0ACgkQz0nQ5oovr7wK2wCgn3SiRjbqky+YLRJ/40XWcUpN
n+AAn0PGfchNovg/dACI0f/vrn8YK7KB
=jIvk
-----END PGP SIGNATURE-----

--L2Brqb15TUChFOBK--
