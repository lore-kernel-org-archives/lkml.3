Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaACCw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:52:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:3376 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaACCwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:52:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,595,1384329600"; 
   d="asc'?scan'208";a="331775681"
Date: Thu, 2 Jan 2014 21:33:46 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCHv3 01/11] mce: acpi/apei: Use get_vm_area directly
Message-ID: <20140103023346.GC1913@gchen.bj.intel.com>
Mail-Followup-To: Laura Abbott <lauraa@codeaurora.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
	linux-mm@kvack.org, Len Brown <lenb@kernel.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
 <1388699609-18214-2-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ZLFUWh1odzi/v6L"
Content-Disposition: inline
In-Reply-To: <1388699609-18214-2-git-send-email-lauraa@codeaurora.org>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ZLFUWh1odzi/v6L
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 02, 2014 at 01:53:19PM -0800, Laura Abbott wrote:
> There's no need to use VMALLOC_START and VMALLOC_END with
> __get_vm_area when get_vm_area does the exact same thing.
> Convert over.
>=20
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Ack-by: Chen, Gong <gong.chen@linux.intel.com>

--4ZLFUWh1odzi/v6L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSxiGJAAoJEI01n1+kOSLHHnMQAJUYxbX5bO/DCVMasvDbRMjl
Asjtkqf8Dzn4l7AN0InmuPUXLvRSDVMwUdtJYIyYr62G9JiySIpLeq05wloUfNnv
9quueR51yCA0y+z18/ImcXD+LBt8YVxwo4oaXNByCy+eq7tWvZ0hXe76g5gUL+f5
053GWAGlxtHAtKm4JCLBx/IxXmC8Y2FleIhacOEv3ernN4FjBbziudy5wSVhy5hh
NT40Scj1MxVXR7afDYzEodLbVpx+e7Voxa+vuNBVoIaT9GCt6FF1DrTOIStSq5CA
29QI8CsP5NCkpEqdpzpnb+EzfFFmwIt3q1XCtrfn3oQVaUARh9uhBib1cV2zygzo
IDmWYzQa97wqGZyydKLXTEPoWO63WRQrIKdcZGLS5rS+2NurgyrsCKBqHWkRY41t
UblgPJWLfD0XBqplpTfq1WvO9bauneZJ9J++4/HOInAxUYRc4QfBmxdE3ipSWOBM
EI8NuqhVlvX9LC6uD49F7i+ugT3l/OHaX3laYBj9xMmbPmdhT4hVVxjfPCI3Eh7e
Be4fI4xGdKK4xWYFL0ulhwktcPeFlAkFe08bhvRYN10YrYQcQ2E0UeLm+qA96Feu
pOJWOhVffl5iCrPS1dLhyOY5AtIS7nDs4Kgd489UT/a4x2QIx0+pRAHoMoY5Kg85
yegIXOfeMuSQLN09+wvq
=xoax
-----END PGP SIGNATURE-----

--4ZLFUWh1odzi/v6L--
