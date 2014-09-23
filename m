Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbaIWPqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:46:55 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57491 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756533AbaIWPp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:45:56 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: balbi@ti.com, Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/4] ACPI / platform: provide default DMA mask
Date: Tue, 23 Sep 2014 18:05:36 +0200
Message-ID: <1430862.A6ximsuo3m@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140923152945.GE28592@saruman>
References: <1408535728-10518-1-git-send-email-heikki.krogerus@linux.intel.com> <2422219.EN0C5cKd3e@vostro.rjw.lan> <20140923152945.GE28592@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4112587.VOX5lP1ZHO"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4112587.VOX5lP1ZHO
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Tuesday, September 23, 2014 10:29:45 AM Felipe Balbi wrote:
> On Tue, Sep 23, 2014 at 05:17:03PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, September 23, 2014 09:52:21 AM Felipe Balbi wrote:
> > > On Tue, Sep 23, 2014 at 04:52:01PM +0200, Rafael J. Wysocki wrote:
> > > > On Tuesday, September 23, 2014 03:17:12 PM Heikki Krogerus wrote:
> > > > > On Wed, Aug 20, 2014 at 02:55:26PM +0300, Heikki Krogerus wrote:
> > > > > > Most devices are configured for 32-bit DMA addresses.
> > > > > > Setting the mask to 32-bit here removes the need for the
> > > > > > drivers to do it separately.
> > > > > 
> > > > > Rafael, is this OK?
> > > > 
> > > > Fine by me, but it should go in via dwc3 I think.
> > > 
> > > huh ? Seems like there's no direct dependency.
> > 
> > Well, it's part of a series where all of the other patches touch dwc3.
> > Doesn't anything in that series depend on this patch?
> 
> dunno, I haven't received anything.

Hmm.

Heikki, can you please resend the series and CC all of it to Felipe?

Rafael

--nextPart4112587.VOX5lP1ZHO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJUIZpWAAoJEILEb/54YlRxOWcP/RLr5w0JgRtmnog0qGGyzgyt
l3h50pX/0YoKPR9q3Ix/rHt632WCm3pH01/5rsNxITMgBIf+arJ0DKP9KWxCd0Cb
7XV6mFqXOkYDanT7+aMNy2pObzPUH7S8E8jyKw4HLUKSg0f1/dEVHo+5j+GXM1XU
bzhj1VLpmi3xDjT7PzEX0lClULhw04qZd8+DmrdZF/OpJL1O1H0YXAkZGM/hHmZv
GGMKuwf4pVO3hYnIjGOwJKW3aANkB6o3UNQPPsevqwXvM67k/UN00i1tS5Px8DKz
wiEIUYt/q5K0gD3ax2ZVrW0nlk0vGi2rur2D++jAdGSxBHVDwHln6qcKZYuXkkIZ
sbq2ncCFoE/Rb524WiVSEQeVQ2dX3MhLMpUm7wOwz3tPllNXwUCXkrcdUnR5atTO
qF88UrpsLj9z7R8weKBtJRTH6nbgHr3TzR8lZfu8Y4jiP+NADl1h95+Z/r0NfrW3
dAvAN93N+BHVHpj5DTFNW+hyKXaz1t7GNwgODmHz+nlj3E9ZzTrZ5fLeXxfKLR76
+AG+2+/+ICccYaEuCFDdltmYs3YkRVZBekMTpr6cvdIlXAl5cHf5A6Cj42RkAbrV
dCCytDW+aIcMMTYApVaLqKF1rQjEKw84xBASu8kA+M0Th8wCkNXAUSbU6dI1URAR
UVpgRNIhXT37yiEWGQzq
=OkDE
-----END PGP SIGNATURE-----

--nextPart4112587.VOX5lP1ZHO--

