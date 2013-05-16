Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3EPR3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:29:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43939 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3EPR3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:29:33 -0400
Date: Thu, 16 May 2013 18:26:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Philip Balister <philip@balister.org>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Message-ID: <20130516172605.GB1627@sirena.org.uk>
References: <0bf5a185-86f7-4a93-a90f-42caefb06a1d@TX2EHSMHS009.ehs.local>
 <519112F9.2010102@gmail.com>
 <7c5e7537-6ed5-4622-a7a9-bf46820ef695@VA3EHSMHS033.ehs.local>
 <519124D3.2040403@gmail.com>
 <af51c63e-7ff1-4e73-9305-08309217ab38@TX2EHSMHS037.ehs.local>
 <20130514164611.10068.46384@quantum>
 <51927DEB.7090001@balister.org>
 <20130515044604.GA24524@sirena.org.uk>
 <51946082.1000606@codeaurora.org>
 <5194F0C0.9020609@balister.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <5194F0C0.9020609@balister.org>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 176.12.107.141
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 16, 2013 at 10:44:16AM -0400, Philip Balister wrote:
> On 05/16/2013 12:28 AM, Saravana Kannan wrote:

> > Agreed. I was about to reply with exactly the same point. I haven't done
> > any UIO coding, but that device file will eventually have to be opened.
> > Turn on the clocks in the open and turn them off at close.

> > Rate to request can be a DT property.

> But you are assuming each device implemented in the fpga uses one clock.
> This assumption is clearly not valid since devices will ahve to share
> clocks.

The binding should obviously be defined as a set of clocks rather than a
single clock - something like how we specify regulators on PMICs
probably makes sense.  Each clock can have its own properties.

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRlRaqAAoJELSic+t+oim9YxoP/1A/Y91neF9lTqA04grJCVbN
g247qOpRrtgVCfsV/qda1yhTEOQtKdXkBVyJO/nDars9pczf4H0YBM55fBgycPJo
rSkU2JcAuyJJn7vUjE05wRXaKxRk1TO1SVZvviVE6LQMabiBYxeSwIrqgakC6Frz
myalDboIZbJ9EgA3gZq6qVWxRsTrqJsL4q3J4vLgfTxa33vdvBlgUlVwMuPItV6l
6ADYNRinrw8y9HE6QLN4semMNmBnQDiF+w6+ggp7aP044gU0574e9jAzGdDfIWbz
44Zo5JXKaTsWccnLGGBqc0pQXM2nf+04HWGK4gjXwjhrLiN8PudMDUasFFibIMp7
eR/o+qE5nB6KmRkGoY0Dyhhjuec1PWaKuH5xYIw/8h47MhgsFnNQppOI12q7IjWL
gfV5ogr+exSuOhVi3YCRl9jwN0YuKzjcOZY82fjPLwQaxLBtMROmw/fUL8T9apmT
s4bfedfNsx1Cw9u7kx6N4tFpchwxZ7bjCzylQ7LKo7+aybtHlQEMAarjyU7YIuRX
TOBGVkoEhQ2kVTS1NmIsa515PDJYt4dzFnXCIUSu5CuWt47fgIblnAC62kYudwF3
gv7iktIq9yGr8zim+BabOwYc/QoSm7mks9adAj4gZp2aQEyOPn5ECx74rGjQkP0r
sYowE0bHlRBSmB8pf+vM
=KI8R
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
