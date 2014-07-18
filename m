Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbaGRISI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:18:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47014 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759713AbaGRISC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:18:02 -0400
Message-ID: <53C8D82B.4030204@monstr.eu>
Date: Fri, 18 Jul 2014 10:17:47 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: [RFA][PATCH 22/27] microblaze: ftrace: Remove check of obsolete
 variable function_trace_stop
References: <20140626165221.736847419@goodmis.org>	<20140626165852.891982463@goodmis.org> <20140715175112.3e9128be@gandalf.local.home>
In-Reply-To: <20140715175112.3e9128be@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="nogRgSMw4WqDkuUfvdiFWBL3sdoqw3iJa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nogRgSMw4WqDkuUfvdiFWBL3sdoqw3iJa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On 07/15/2014 11:51 PM, Steven Rostedt wrote:
> Michal,
>=20
> Can you please test and ack this and patch 6 of this series. Otherwise =
I
> may have to stip it out of the series which will break the build on
> microblaze.
>=20
> You can test my branch at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git=

> rfc/remove-function-trace-stop

I have tested this full branch and there is no issue on Microblaze that's=
 why
here is:
Tested-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal











--nogRgSMw4WqDkuUfvdiFWBL3sdoqw3iJa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPI2DUACgkQykllyylKDCHVHwCdFN2HCNBBNuZkfZBaWKM7Iedl
GzAAn0sQJuhc5NLobEt7iE3qCUKl22Fa
=kG0E
-----END PGP SIGNATURE-----

--nogRgSMw4WqDkuUfvdiFWBL3sdoqw3iJa--
