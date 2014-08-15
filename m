Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaHOHoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 03:44:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:53135 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaHOHod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 03:44:33 -0400
Date: Fri, 15 Aug 2014 09:44:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, eranian@google.com, dev@codyps.com,
        Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 00/14] Add support for parameterized events from sysfs
Message-ID: <20140815074416.GA19379@twins.programming.kicks-ass.net>
References: <1408087583-32239-1-git-send-email-sukadev@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EIpds50fuTT8wE79"
Content-Disposition: inline
In-Reply-To: <1408087583-32239-1-git-send-email-sukadev@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EIpds50fuTT8wE79
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 15, 2014 at 12:26:09AM -0700, Sukadev Bhattiprolu wrote:
>  include/linux/perf_event.h                         |  10 +
>  kernel/events/core.c                               |   8 +

Those are patches 9 and 12 iirc, no objection to that.

I've not had time to actually think about the rest, seeing how I need to
pack today and jump on an airplane tomorrow its unlikely to happen
soon.

--EIpds50fuTT8wE79
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7bpQAAoJEHZH4aRLwOS6EcUP/1kZo7AHPBsEtWcPZjpjhe3k
YKCxgaFiu/+DkWtN/fAkLyyn658cKMgNKRYpwAh8JIJlUTXe9VvL2rtv8bp3NrpI
KbIYozkoGP2Q4vmIB1hlmWtGBx+9SQyB0AdCmB018mXCBQCEkYhHM44Wxv+Ckw2E
yGt6JmjwkRY0zBeUSP0ulwhhH3iDOMk8CMzerAyIn/T30kNPBSBE+qDfzvtslLcc
9Yd1Odl1+13B0SFJGoJSkF5wlJ43jXcXdvJiM1EuKg8opORhFJrbsqovJSWCfL/z
f03XcZSgGS21YdUAkOmZC/mvf2OcZTw2T2fkaB30ernYLWtqt4IQU0I5d3bL+FW3
xh7hbxs7+Hawh8qkoqoEFctE27GIxF5ffPu+vSkgt1FXKolwJhj8NvqiKAT8S8BZ
/GjpLf0dGZYWC1WJo4BKOLVCLcT7dWt/lfoVAamqCzne+4hwviWhonNAlIt8d29o
nB6ebXvxkJuAFtKU3rIhAGPLGRnUa6GcwksqP3DXNnED5RPd843kcPbf3Vb1zf0E
FVSgFtNIq/rSiesCi9GMj3xthkA1m2iyVf+F5xLEyPTzEacm+OTjHupjUYPTOVbm
l3Bmsd3Zjlo2A7TVEwR55tgFoarHTS7Tn/IAwtWzLZdCV39DaK/O8pkMWqX8KgPm
xBb6NxkcgJlL8CyXZYCX
=pQfv
-----END PGP SIGNATURE-----

--EIpds50fuTT8wE79--
