Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3HTWoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 18:44:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3HTWo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 18:44:28 -0400
Date: Tue, 20 Aug 2013 15:44:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.9
Message-ID: <20130820224426.GA25146@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.10.9 kernel.

If you don't use networking, you can stick with 3.10.8, otherwise I'd
recommend updating to this version.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                |    2 +-
 net/netlink/genetlink.c |    7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

Greg Kroah-Hartman (2):
      Revert "genetlink: fix family dump race"
      Linux 3.10.9


--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJSE/FKAAoJEDjbvchgkmk+iUAP/1uUiShAk4teYeU4S4ggH2Jj
QYHhl+YZSWJvS9P2zKmNzKF5GuRcxMaFsDRwWrDHYIbPAUXzDf0FNQ8t/u9W7M0S
qmP9aDLY+1mgTZEH/zxkbEJME3MDMx1X7R3x6b+9nliG2TXCLyR7UcY3JiC+9fjn
2avezFBOlGDB/k62jpFA62vWlqRyhK3bPUSU6l23mlhRPvFBPhFRFYUe8XW95OOU
3W7tkUtHO1GbCzpjUGmrfl6wLOESuUWOoN+0O0cwXPi3LINyO5f4BunjjAdcmxXM
Z+2pWANAcobnlyzZoDqN78ZhbyzFUOIA2Ka1r89/8iItv3KIJhV9E0D2fiaxf6ua
ichGe7kTcdbnjJ9NbgIKlv2SS6eVPSUNzpTZwyu0qYJSfFf03jmjS8v6YztczKEd
80gnBTsTdSN5M2U1xSt5HMp4P2ciyUF8JCTg/Swvl7S1lJEvuJz/3W0wbGY3NaDG
QRstHr7ozdRHSO4ZgnAaJNeetruvUFttVjGOgT6HhxLBiJpKp/f0iJMs1KDeYc6a
UCcYqFE2HWc8Nly004BmxNHHAjO8xyc4meOSnYaiL7Q61o3bXdjVG7eOMMW7qawD
SqqbCXaptAZ9NACKO58RzyUujTiPJFD588ArsTAeagE/HN6JfM4Edhq1XtXst3+O
OWgBFKdvlwhS5l/B/eQ+
=O65L
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
