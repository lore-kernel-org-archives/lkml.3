Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbaIOWMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:12:36 -0400
Received: from gloria.sntech.de ([95.129.55.99]:50137 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397AbaIOWM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:12:29 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Subject: Re: [PATCH 3/5] dt-bindings: add devicetree bindings for Fairchild FAN53555 regulators
Date: Tue, 16 Sep 2014 00:14:43 +0200
Message-ID: <2217201.MLW1SzL0fz@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140915215410.GB7960@sirena.org.uk>
References: <1410722585-13393-1-git-send-email-heiko@sntech.de> <1410722585-13393-4-git-send-email-heiko@sntech.de> <20140915215410.GB7960@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1640997.3ONdSdnbW3"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1640997.3ONdSdnbW3
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Montag, 15. September 2014, 14:54:10 schrieb Mark Brown:
> On Sun, Sep 14, 2014 at 09:23:03PM +0200, Heiko Stuebner wrote:
> > +Optional properties:
> > +  - fairchild,suspend-regulator: regulator number to use for suspend
> > voltages +		possible values are either <0> or <1>
> 
> I'm not sure what this means - What exactly is a "regulator" in this
> context?  Are there really two separate regulators?

The fan53555 has two voltage selection registers (VSEL0 and VSEL1) which can 
be switched through a gpio ... to use one as suspend voltage.

So it's just one regulator output but can select one of two voltages.
--nextPart1640997.3ONdSdnbW3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABCAAGBQJUF2TTAAoJEPOmecmc0R2B1FsH/j2fXuHJoxJIsDq91Vhsyz40
SUa1dkNmKL4U4e9wa6dOat1JU1IefXoW8hRkQ1jhEoQPPiFbNNHnIxW2B7MIU051
3BpcTCYoxx+hP4b87fRxp/RmpGhLVLSWEA660QVvD7hZ10b9OJttAFitsQK0J0kV
EdFd9r9LiSgEyu0/mBL2MACgZwPor6G0mhdAs38qlvK9aaBcnTqFjR/Vq0bwAMpR
IJ5wsPPky/OmNHgyVZIFy8h1l0tX51nxdtQjRpZ02Ds6Re3JERkVv9KqUUXL7j38
I6ZK9ZnUtPSeyI+WZRd0kTl0LeOp/t9OCFBm5i5uWpEFf/Vg4Bff6URn4m+mOqc=
=HBi2
-----END PGP SIGNATURE-----

--nextPart1640997.3ONdSdnbW3--

