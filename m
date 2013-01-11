Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3AKPCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 10:02:18 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56755 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab3AKPCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 10:02:15 -0500
Message-ID: <50F0296E.2000704@imgtec.com>
Date: Fri, 11 Jan 2013 15:02:06 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <20130111103442.b80ddbfb11ef322ed28ca3b3@canb.auug.org.au> <50EFD824.3010502@imgtec.com> <20130112000336.1f24c42237fab4fe0c305ff6@canb.auug.org.au>
In-Reply-To: <20130112000336.1f24c42237fab4fe0c305ff6@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigAEBAD9ED7F3CBF3A8415926C"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_11_15_02_13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigAEBAD9ED7F3CBF3A8415926C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 11/01/13 13:03, Stephen Rothwell wrote:
> On Fri, 11 Jan 2013 09:15:16 +0000 James Hogan <james.hogan@imgtec.com>=
 wrote:
>>
>> On 10/01/13 23:34, Stephen Rothwell wrote:
>>> You really should not base development work on linux-next and before =
I
>>> can include it there you will need to rebase it onto Linus' tree (or =
some
>>> other tree that does not rebase).  Its OK to test by doing a merge wi=
th
>>> linux-next ...
>>
>> Thanks for the info Stephen. So I suppose if the patchset depended on
>> things in -next the normal way to do it would be to merge in the
>> individual trees I needed first?
>=20
> Yep, but please let the maintainers of those trees know that you expect=

> their tree to not be rebased.  Or, if if they aren't really dependencie=
s
> just conflicts, then leave the other tree out and let me and Linus fix
> the conflicts when we merge your tree.
>=20

Okay, I've rebased the metag tree from linux-next onto the master branch
of Al's signal tree (to get Vineet's GENERIC_SIGALTSTACK fix and
GENERIC_SIGALTSTACK's eventual removal).

git://github.com/jahogan/metag-linux.git
branch: metag-core
tag: metag-core-v3.1

Cheers
James


--------------enigAEBAD9ED7F3CBF3A8415926C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ8Cl0AAoJEKHZs+irPybf2hAP/AiKST0JbqNY2uCwBakkFyIt
iwsqU7B5RZG1R9ExEdyGE69V8PK3FS1OMt3cja5G8bppsopjzcHR1mW/r0hJ4rlu
hZ25+yABlZUxctmxIsxXzcerNLQ/Fd7IUjpOEMlroR/7o2UooF1C0wykVgMcB0za
B1DUQlArTtYKthYDtzMeXEHgrBWM6yRy0tbnDLZB9eJgbvxET9mL6X95tnJxwrjD
UDA0bbOyleJa5LyGsx6+L2RCgvgbxc4Ys77PvnSU52Tzs0qdIxqhyblsiuNRPGyq
SPC+MxvCZRrq66EG6yDLQcVhyZXLj56GvseLE2NsTqIgmzUGz7uDDIXRiM/xP7N8
pdNBJUlKwvkR4ztbScS2oUYuzzqf7xhodCbNVM6Jdp82uLOXbrISgYiXkJ/5UDIi
M7PQa70DKuaZtXUYaSxvIw0DH3zyQCaSg/M0y7ivfo+AuO2MHFpaZQapY6uoxKCA
n+YIJAg07/lpw26SWqAWrKCiyHNUB4y6A1I1INOADMIbxOLzBNzVPVRuqdRysLQj
cWozwOWQ/zA2RDoJ5cHe65CAqEyNn1DkiZR96OaCoST3X+oEahuwTV2G3E431gZa
JBJu2lLsHlUuxgcn7PaYwo0dzLNvfHJr/nxIO2r2DAmPIhgArTmPw+GXp92g/RaY
yMYaEhJWnMSupoG3zHi2
=vMXK
-----END PGP SIGNATURE-----

--------------enigAEBAD9ED7F3CBF3A8415926C--

