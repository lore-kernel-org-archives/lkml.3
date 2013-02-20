Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935153Ab3BTEKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:10:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935140Ab3BTEJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:09:29 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=SHcKKu4J39IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=IneQv0fk5xMA:10 a=VwQbUJbxAAAA:8 a=B-oAMj-qqYvT0PzSWREA:9 a=QEXdDO2ut3YA:10 a=SMnhBXLM0T3xvWLooyEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130220040728.921685169@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 23:07:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/7] [GIT PULL] ktest: updates for v3.9
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

Updates include:

 o Added ability to have all builds test warnings.

 o Fixed failing reboot when the reboot produces a non fatal error.

 o Config reading fixes and other cleanups.

Please pull the latest ktest-v3.9 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.9

Head SHA1: b4e059fa0c07e0c054dab9a48c2e3f7d7d4563be


Steven Rostedt (Red Hat) (7):
      ktest: Do not require CONSOLE for build or install bisects
      ktest: Strip off '\n' when reading which files were modified
      ktest: Allow a test option to use its default option
      ktest: Add make_warnings_file and process full warnings
      ktest: Search for linux banner for successful reboot
      ktest: Ignore warnings during reboot
      ktest: Remove indexes from warnings check

----
 .../testing/ktest/examples/include/patchcheck.conf |   37 ++++
 tools/testing/ktest/ktest.pl                       |  190 ++++++++++++++++=
++--
 tools/testing/ktest/sample.conf                    |   44 +++++
 3 files changed, 253 insertions(+), 18 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRJExnAAoJEOdOSU1xswtMeVEIAMf4RT7KjxseyJ/+XVhzc4B9
ZiUF5aji3hRRmDMWQpMMGqz355pqP52aM26ERkoKhiNKRa2wvnpbXyQmuU1wzxa2
X9CC7YVHTS2mn5Wa307/qsZNRk0WeG8ANzMCwjmwXiBOyweDI0I1fY4ONLv9bfXX
QboIcspjfnKpA8HyklFKxXpucg7q9Stv+i05e4X5BDH3JL8M5Skqoq7WwHFDWa0B
N+McS05bva9DGIX6d+A2zDzPht0Q7CatmwENd9W9jQ8XN0VT531tcv09cVwisDX5
tE8iXPbXv/lHEXJjsonZDxZ1GgIN3clI+1xql3S1ykGA6P3LcM/c72iVE70m2cI=
=I8I2
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
