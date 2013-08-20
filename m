Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3HTPDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:03:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38527 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3HTPDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:03:33 -0400
Date: Tue, 20 Aug 2013 16:02:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20130820150247.GO30073@sirena.org.uk>
References: <20130816224654.GV30073@sirena.org.uk>
 <Pine.LNX.4.44L0.1308162117240.24059-100000@netrider.rowland.org>
 <CACVXFVPFqHLQRpd0QBzoVapqHtKqrfGvWT0_nhXeFqjQVRsp5Q@mail.gmail.com>
 <20130819160130.GD30073@sirena.org.uk>
 <CACVXFVOi+pa7G-D91V05qF0Y65rX6ZKk-=i_sbFwL3PCGsdyPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eK+CmkWoJZNLCSBz"
Content-Disposition: inline
In-Reply-To: <CACVXFVOi+pa7G-D91V05qF0Y65rX6ZKk-=i_sbFwL3PCGsdyPw@mail.gmail.com>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eK+CmkWoJZNLCSBz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 20, 2013 at 09:19:07PM +0800, Ming Lei wrote:
> On Tue, Aug 20, 2013 at 12:01 AM, Mark Brown <broonie@kernel.org> wrote:

> > I can't parse this at all well - why would DT want to refer to ACPI, do
> > you mean people may wish to look at the code as an example?  As Grant

> I mean usb-acpi provides one approach to retrieve platform data for USB device
> during device enumeration, and the idea might be helpful for you to implement
> similar things based on DT.

Ah, OK.

> > noted DT already has some mechanisms for enumerable buses which looking
> > at the code appears to be broadly what that's doing.

> If the mechanism is ready now, so looks you might post code for review
> and discussion?

There's nothing there for the problem I'm talking about here (devices
that haven't been enumerated yet) and I don't off the top of my head
know if the enumerated case is supported by any buses in Linux yet.  It
is part of the DT specifications and has been implemented on other OSs
but I'd need to go check if Linux actually went and implemented any of
that.

--eK+CmkWoJZNLCSBz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSE4UUAAoJELSic+t+oim9rHIP/iJm9ZXxHoyG4gEVtCT+nG0X
Bi4T1aXMbOtc40D+hHZDlY35pOiXRHGY6J3Pm9YjrgSUY4mQOYEyF1+iUMgEjx7F
yn6dnLE1HfAQ69hcdAiCg0VxFxIbwSSdZ8wG2gs1NMG9UVsrQSKcTVEdLWXFVuEQ
zomSZo9Dlvdqujfp9M/WkogFrOJEY3dvPqgFXwECtU/WuWQo8xYtb+rpz8R04P3I
V3yLMdF0atOhkkHTNWvqdLZWGHssew8zeHlKLERRxvyBGzVbMF7YyW+zgu/hvf7g
0C7p9PTXF4qPJUWY45X8QSmlx+jpdQGbxha9uCw117lp2ZGLdazsuT9dDXim5gvl
byntV9V5LE3z5MnsQUybXx6FSa8tIx2OZghiUbtOEzL9mHsDi6uwXd3FPnowXL4a
lUgjwcMt7eRiUNh4sY1PtJEmVzrgciaZFncgxvUN4TiVGdxseO0Esom757pCkMVX
dwSjnWsCyWS1UrnRMAinaxXuGdNAY+EKlnsectdLV8nEC2DIriFIUr9Seum1K+dV
NfoCa1auaBu+C7/1qZjsD1VKrd4MkTkS53Vk4b0N94x4BNMHmigbV98VVXWEe6je
kFKwTBINeveA8p2PkhfUcSq8Ir+1pl6WcK6rbsNul0ntcOu0/fkTommS+dx+mLjL
WZp98pQ+6FpcFkFWeRnn
=0I+K
-----END PGP SIGNATURE-----

--eK+CmkWoJZNLCSBz--
