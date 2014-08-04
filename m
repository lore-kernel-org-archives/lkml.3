Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaHDTXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:23:21 -0400
Received: from omr2.cc.vt.edu ([198.82.141.100]:46091 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbaHDTXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:23:18 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Nick Krause <xerofoify@gmail.com>
Subject: Re: Kernel Debugging Support
In-Reply-To: Your message of "Mon, 04 Aug 2014 19:07:53 -0000."
             <A2CA0424C0A6F04399FB9E1CD98E0304844C4028@US01WEMBX2.internal.synopsys.com>
From: Valdis.Kletnieks@vt.edu
References: <CAPDOMVj5nifG8VQBB_UzNESBc+arxpCQ5sEOAYdb6Rr-KkDSHw@mail.gmail.com> <20140804164633.GA28436@xanatos>
            <A2CA0424C0A6F04399FB9E1CD98E0304844C4028@US01WEMBX2.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1407180184_2589P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 04 Aug 2014 15:23:04 -0400
Message-ID: <58974.1407180184@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1407180184_2589P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 Aug 2014 19:07:53 -0000, Paul Zimmerman said:

> Are you sure about that? Last I heard, xHCI debug support was a logo
> requirement from Microsoft for Windows 8 and above, so I would have
> thought that most vendors would have implemented it by now.

There's a lot of gear out in the real world that was manufactured before
Windows 8 was released.

And the actual requirement, as listed at:

http://msdn.microsoft.com/en-us/library/windows/hardware/jj128256

doesn't actually require USB debug -it requires a debug port, and xHCI
is below ethernet on the preference list.  As it says:

---
The next version of Windows will support several different debug transports.
They are listed below in the preferred order of implementation.

Hardware Debugging Transports

Ethernet Network Interface Card from the supported list: http://msdn.microsoft.com/en-us/library/windows/hardware/hh830880

USB 3.0 - xHCI controller compliant to xHCI debug specification.

1394 OHCI compliant Firewire controllers.

USB2 OTG (on supported hardware for Windows, recommend XHCI debug instead).

USB 2.0 EHCI debug (the debug enabled port must be user accessible). Legacy Serial (16550 compatible programming interface).

 ADDITIONAL REQUIREMENTSFOR ALL OF THE ABOVE IMPLEMENTATIONS THE FOLLOWING MUST APPLY:

There must be at least one user accessible debug port on the machine. It is
acceptable on systems which choose to not expose a USB port or any other
acceptable port from the list above to instead require a separate debugging
board or device that provides the ability to debug via one (or more) of the
transports above. That device/board must terminate in the same standard port as
would be used for the transport if it were \u2018onboard\u2019 the machine. If
this device is required it must be documented in the system specifications, be
user serviceable, be user installable on the machine, and available for sale
from the machine\u2019s vendor.


--==_Exmh_1407180184_2589P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU9/dmAdmEQWDXROgAQLxGw//cUvlgamCkPT28cl7HFYHx3X7Sr3RjoeT
SD1fAnHHGIiY/jY0bK81RWq8CLl3pSvkJzMObVz4I7EodwFM2Ms4xFzSUHlhS1DU
rX9wmdWKwFy7WO55Ld7bPxRetxON9RKMPz+CyCJAJkgq874VtVTUtN5WDHtuRscD
tos8A/HJ/OdcPS4aFwmRVhk8GfPs5GsFO3MjVJlNrGTxbj9x62/tPqc/tX6SZBZA
EmO1KG4hA+1OTzmYXY/zIWK93t5W8fVxjTu9kCPhrAEhU7wylUZU23+QlisgcVlU
XauVC3epO/mMIWRKvm56HZnwxmg01/czNDffzNajkuZV7X56luj9qgw6bQzlYpA8
2olSMCaDDn+y1EotDphlHoXgYZEb2nxikt1bE+C7NyHEMmUSRjjteGRzk7eTw8kY
Y7ETvMpZZsEqHs9zIKwRm8MfYNNuU+upWdz93ceNqSXGoTMvK4ZI7oFEGjC9tKZL
rR0rE8CEPCyb+kd+0RvhaZhYQzvcBYwvYYpLlTqL0BS8MZ+0BqDTdOIVRhgmfOAn
2GJm4hZVCoqy80WmuJLM6GqQT00I4NSo23ap2jUaMHCtunfJykZ0mtAOF+t3bhKi
8JzE+aNdnGt7iRYiLEKfW0JNaaJK9F4LUOBAJbyjmAmKl9wz9Bqh9V3NHreEVJ2Q
H9Px9IQOsMU=
=G3N5
-----END PGP SIGNATURE-----

--==_Exmh_1407180184_2589P--
