Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbaGQXn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:43:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131AbaGQXno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:43:44 -0400
Date: Thu, 17 Jul 2014 16:43:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.99
Message-ID: <20140717234343.GA16774@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.99 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                          |    2=20
 arch/powerpc/perf/core-book3s.c   |   17 ++
 arch/x86/mm/ioremap.c             |   26 ++-
 drivers/acpi/battery.c            |   27 +++-
 drivers/gpu/drm/radeon/rs600.c    |    6=20
 drivers/hwmon/adm1029.c           |    3=20
 drivers/hwmon/amc6821.c           |    2=20
 drivers/usb/serial/cp210x.c       |    1=20
 drivers/usb/serial/ftdi_sio.c     |    3=20
 drivers/usb/serial/ftdi_sio_ids.h |    3=20
 drivers/usb/serial/option.c       |    2=20
 fs/ext4/super.c                   |    7 -
 kernel/cpuset.c                   |    8 +
 kernel/rtmutex-debug.h            |    5=20
 kernel/rtmutex.c                  |  252 +++++++++++++++++++++++++++++++++=
-----
 kernel/rtmutex.h                  |    5=20
 kernel/trace/trace.c              |    2=20
 mm/mempolicy.c                    |    2=20
 18 files changed, 321 insertions(+), 52 deletions(-)

Andras Kovacs (1):
      USB: cp210x: add support for Corsair usb dongle

Anton Blanchard (1):
      powerpc/perf: Never program book3s PMCs with values >=3D 0x80000000

Axel Lin (2):
      hwmon: (amc6821) Fix permissions for temp2_input
      hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div

Bernd Wachter (1):
      usb: option: Add ID for Telewell TW-LTE 4G v2

Bert Vermeulen (1):
      USB: ftdi_sio: Add extra PID.

Christian K=F6nig (1):
      drm/radeon: stop poisoning the GART TLB

Greg Kroah-Hartman (1):
      Linux 3.4.99

Gu Zheng (1):
      cpuset,mempolicy: fix sleeping function called from invalid context

Lan Tianyu (1):
      ACPI / battery: Retry to get battery information if failed during pro=
bing

Roland Dreier (1):
      x86, ioremap: Speed up check for RAM pages

Steven Rostedt (Red Hat) (1):
      tracing: Remove ftrace_stop/start() from reading the trace file

Theodore Ts'o (1):
      ext4: clarify error count warning messages

Thomas Gleixner (4):
      rtmutex: Fix deadlock detector for real
      rtmutex: Detect changes in the pi lock chain
      rtmutex: Handle deadlock detection smarter
      rtmutex: Plug slow unlock race


--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTyF+vAAoJEDjbvchgkmk+MBsQAMXFdql4+UaHVF6L59KcALbH
RigdNgkorU0k+Nu056BGSe6ejVblEKgIwiCsAVMqkUNllKQKwg0gV/97+8R+2mrs
QGiLdkl081eU9oTDImqYohXkap6jndDl68DfpIHI1wOk3mh2CeBpSN86f90gwB+F
bPTyIJ0BrirZ0dKmL8GW4HytcyqpttHhkiBRp+ES4bS1J8JwfqAcVrkivx28B2fk
vXSgFWHQHjMS5iTQebpK4AC8Q3XNZUm42kk9WGi8v2F+K8Gbz3XrFaqV8ZjIhX+u
TRzfs1+rp3hx8/zqXpQhsnpUfapTLcgkWw9IAXnk4zU6lhIm6+vI/0WM0FtiJsl8
lZKtrktPfLjAtqv8BSrMT1Hn1F2ubD3cQUkR3vhUEeGiVHQ9e49kt2zHXUEuCNQD
Thx5l3q45QcgubFTTu5PNkU8UxE3AjvLpOtagu/ll1UuC/KWoxpB6541vb1VbT74
i4ri+JJNkfeDSlKmYx7uGVHRlKxQQVVm3aaRAjTYbDTYs9FjIPxI5X5znl67FgkK
RiS49wjEN/fqOLWKpVbNoRHOzM9TE8scET2M/9t1nuLfQgO7XdiZLE12bX7Q0w2Y
i5NQzCHj2dao12ueTHGcYhghqKdcr/AU8/WSWlCvNStQWrhwljW8fdKtIthGlDUS
o8roEIB5iaT0lL+FGJJj
=g7UD
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
