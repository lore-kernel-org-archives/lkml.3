Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaFERah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:30:37 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57204 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaFERag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:30:36 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: linux-next crash in xhci_add_ep_to_interval
In-Reply-To: Your message of "Thu, 05 Jun 2014 09:35:48 -0700."
             <CAPcyv4gYnvF4Nt5itkDsD=DzL8sfETZUBmQqZwiHE1SOZvtsbw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <18529.1401981749@turing-police.cc.vt.edu> <CAA9_cmfje+8qAh7NqjHi1zcRAPZgJ0xdOK2nM7TKN9NRgqcRfw@mail.gmail.com> <23223.1401985468@turing-police.cc.vt.edu>
            <CAPcyv4gYnvF4Nt5itkDsD=DzL8sfETZUBmQqZwiHE1SOZvtsbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1401989394_1971P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 05 Jun 2014 13:29:54 -0400
Message-ID: <33745.1401989394@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1401989394_1971P
Content-Type: text/plain; charset=us-ascii

On Thu, 05 Jun 2014 09:35:48 -0700, Dan Williams said:

> Actually, on second look I bet xhci_alloc_tt_info() is being called
> while hdev->maxchild is not set.  Let me throw together a debug
> patch...

Sure, no problem - just let me know what variant of linux-next you
want it applied against. :)

--==_Exmh_1401989394_1971P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU5CpEgdmEQWDXROgAQJlKw/8DwcTd/4vU5ff4eGON9xPvEIXV4EE31jS
NoQyu5ZyuxktTXCHiM/KWCGw8kzXle+/A2bIPgVO6MO9pp9KNxYvmc3GoWyV7hof
a2P/paj7zC4sXgXrFvRhePmnKSZpwQLWkw+NwP7bmt3GQv+YGcYbfcTmIqjuLGI6
EDHVsFAB3KUxyM6uGgwnx9vIQcSxY1Kazc7XVkcmY8aivgkjE8PCoeD4gNpwO5gr
EifME164dJ1ZoXq0+cderVTyEbm3syCwoxbNPeUrxzGRlOM4WWkVZuYIbaFfWlZv
3dTtPQsqb3zquzPPceNwtwGn+DXSSfV+5aQ1zHwyLkgpvd7RFH3MeTe0oY38mInj
BfxlHfrlUujEzE5wwcue/5/jkEJd+O3YoVwkhsLWbIyuG/jTVpzEaALR6uUlxypB
3L/GfDPO9838RLn6iFS02OP3nTRZWxwM03hHleH3Qh1ukq8++Odvr9+4xJ2QSrZy
/s5QTtfDIzrCw7JE7OPt/p1LgEGOVaa2Qho1sNvQZedN1uMA2RDBvYJy+2gRIHtp
aLzGbQoRrlv1Wvj/7Xb0uK2X5hWHD8zcpKtJxNk0CabhupSPTm6p3V1vkC2KRKwf
/VyINd7VUJqSHT7+5T349u/6/nbViCxm3Tb0Iy3nyHFGEnXkHwbMeQXIb5tWIDIg
Zoj5eYFUMps=
=X3j7
-----END PGP SIGNATURE-----

--==_Exmh_1401989394_1971P--
