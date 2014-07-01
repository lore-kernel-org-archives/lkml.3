Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbaGAHaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:30:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60878 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752883AbaGAHaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:30:04 -0400
Date: Tue, 1 Jul 2014 09:26:47 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/6] arm64: Support restart through restart notifier
 call chain
Message-ID: <20140701072647.GI28647@lukather>
References: <1404155499-21177-1-git-send-email-linux@roeck-us.net>
 <1404155499-21177-3-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BghK6+krpKHjj+jk"
Content-Disposition: inline
In-Reply-To: <1404155499-21177-3-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BghK6+krpKHjj+jk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 12:11:35PM -0700, Guenter Roeck wrote:
> The kernel core now supports a notifier call chain to restart the system.
>=20
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  arch/arm64/kernel/process.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 43b7c34..9dd2abd 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -43,6 +43,7 @@
>  #include <linux/hw_breakpoint.h>
>  #include <linux/personality.h>
>  #include <linux/notifier.h>
> +#include <linux/watchdog.h>

I don't think you need this include, or shouldn't it be reboot.h
instead?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BghK6+krpKHjj+jk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTsmK3AAoJEBx+YmzsjxAg1yQP/2dBQ6t2CgNiPdeK1O4Za6R0
9bDGZytwBJ9dDcOBH5j6r+VX6u4yChMRb+ZvI5QCoSftVTHRwMcavpXSJygWEgwt
lIBTTgehDWCT64YWY0AUpXmxXNb1ZfGqsuVgQqlloN6p8NDBTITQnD6nZbHiwNPx
HvhOuYbzs/KMXAYDydukVSO8TB3vzltZxQcHCOKtf3IZJeKI84FEI8ga2sHIycXr
N2hVIDWz5htfKA1028u6KSxROnQgOhEb+oXp9QQNfDLLmSna8nF/3CD0lRH1y2L3
CrVdwBpXXbY6yHAarrTUihrvR0HWBlMy3MSy5y1fAEzGktNxNKqba6JQ6p8emAm0
m3sRzTWOwHwhDw01OP9PeKF/KTa4hHSbjd9wd0VKGEhCcj8QB+qubTEukGLPsNvy
QrB4XOFmeT0Rf1CCNKetrS0vWuhYvfauajpGi65eZsxTu96NKllfQSo8FgW8bznG
Gr8FtISOa26jFlbMUuGD4uHDI0RguDM3izMM+RQCzVabD9y+o4kzTnMgsSQjamVu
2+e5R42iCrvFwKwz3dYsG8POd/RraZfnNggudaCdk31SSz0zUhaKAl3T0J5xoxM9
G/oF0JbGntLG8vVlrXFK39P7nvRV+QaoWorBtkUEXUWHJz3rO/Y9wKFlyfLznSpo
7GQ+PndJmbibczTQdLP5
=4rRR
-----END PGP SIGNATURE-----

--BghK6+krpKHjj+jk--
