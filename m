Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaHTUSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:18:44 -0400
Received: from omr2.cc.vt.edu ([198.82.141.100]:45562 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaHTUSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:18:43 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-firmware@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: Automatically pull missing FW files
In-Reply-To: Your message of "Wed, 20 Aug 2014 12:21:23 -0700."
             <53F4F533.5010308@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <20140820182145.15596.86122.stgit@tstruk-mobl1> <1408559681.11365.1.camel@shinybook.infradead.org>
            <53F4F533.5010308@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1408565832_20555P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 20 Aug 2014 16:17:13 -0400
Message-ID: <22524.1408565833@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1408565832_20555P
Content-Type: text/plain; charset=us-ascii

On Wed, 20 Aug 2014 12:21:23 -0700, Tadeusz Struk said:
> Hi David,
> On 08/20/2014 11:34 AM, David Woodhouse wrote:
> > I'm not sure I understand. Precisely what fails?
>
> I clone a subsystem, configure it to use
> CONFIG_EXTRA_FIRMWARE="qat_895xcc.bin", type make && make install and get:
>
> MK_FW   firmware/qat_895xxc.bin.gen.S
> make[1]: *** No rule to make target `firmware/qat_895xxc.bin', needed by
> `firmware/qat_895xxc.bin.gen.o'.  Stop.

Is this what you were looking for?

config EXTRA_FIRMWARE_DIR
        string "Firmware blobs root directory"
        depends on EXTRA_FIRMWARE != ""
        default "firmware"
        help
          This option controls the directory in which the kernel build system
          looks for the firmware files listed in the EXTRA_FIRMWARE option.
          The default is firmware/ in the kernel source tree, but by changing
          this option you can point it elsewhere, such as /lib/firmware/ or
          some other directory containing the firmware files.



--==_Exmh_1408565832_20555P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU/UCSAdmEQWDXROgAQIKLA/+LEc+DbfwJpVyHc64l17kkVYH2CH6IAoy
7hZ5lHXiF2JR2XVMzFZA9GDLiCAYJ/iCRbt7PW48piApka5nZhXiEzJPml0UD83E
7hW/8g8RWDx0U2PgerAGwexhi0tGA2hQBAk00JS3XY4o4K/POL1dGag1RxWlo5q/
EbL9/sFDRlI3Vl3y4QlXdY62rY5zD5W6ZmnvNCh+Tk2406RWN2PVyLl6uypEGUrj
sosjQep5InWqEe3dHIfslry2UfC+UAmlPiZ7BBknP83bhiGjcQgcLSspdSDT3vNW
GY/TYSUhqOQxp14++P5P/qqRVSlHvLDMxFkBbzPznAz1A2JaFDx1SU3wmJF3i/uv
icvPhvIDHhqGgQ7Lawg/0IidUuhb1tPNmEZr+CCQNep6xzUjWoupRfGd41Fmyp/Z
1TB+DexEjKqWGn2YN9NiNQ3FMJWLEffCuWGRqBVNndrxsCswCv9kPFlv4Kw3AWGt
rcH65A29kbQ4NmrR59yGSEiB7AXP90AY+LG5w0Nn8tTwaDP14B0IVNLz3FDqBpV6
St3LVr9yFsctY/LNzyLcPU6c1eIPphdK1JwNLOKyrW6m2Ga9TqjQZJx3RvaNAfEr
sGT9ETWKJ1JrK5RK9JNIk/9Fb9zvfdQJuQGxx+wZ0O3WGq5tGq7v1SojAM8pxNZF
vO7+eojzbtc=
=WQLp
-----END PGP SIGNATURE-----

--==_Exmh_1408565832_20555P--
