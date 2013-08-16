Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3HPKIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:08:24 -0400
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:40857 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3HPKIR (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Fri, 16 Aug 2013 06:08:17 -0400
Message-Id: <520E162A020000A100012427@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 16 Aug 2013 12:08:10 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Wtrlt: Q:  NFS: directory XX/YYY contains a readdir
 loop.Please contact your server vendor.
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartD7E4851A.0__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartD7E4851A.0__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Re-sent due to "5.7.1 Content-Policy reject msg: The capital Triple-X in =
subject is way too often associated with junk email, please rephrase. ":

>>> "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de> schrieb am =
16.08.2013 um
10:29 in Nachricht <520E15EF.ED38.00A1.0@rz.uni-regensburg.de>:
> Hi,
>=20
> recently I found out that we his the "NFS: directory in/mdoc contains =
a=20
> readdir loop.Please contact your server vendor." frequently on an =
NFS-Client=20
> running SLES11 SP2 (3.0.80-0.7-default). The NFS server is also SLES11 =
SP2, and=20
> the exported filesystem is ext3 with "dir_index" on.
>=20
> SLES support suggested to turn off "dir_index" in ext3, which "should =
be=20
> safe".
>=20
> I googled the problem, and I found some (to me) vague description by Ted =
Tso=20
> ("If not readdir() then what?") back in 2011 referring to ext3.
>=20
> Now I wonder: Is this problem restricted to just ext3, or to any =
filesystem?
>=20
> We have (and I cannot change it) directories with many files, even if =
just=20
> temporary.
>=20
> The statistics say: "122431/524288 files (3.4% non-contiguous),=20
> 1230006/2097152 blocks"
>=20
> The biggest directory has almost 1MB in size, but just about 16513 =
directory=20
> entries.
>=20
> I'm wondering whether "directory compaction" (compact slots of removed=20=

> entries) would help with the problem. In HP-UX VxFS you could do =
directory=20
> compation online...
>=20
> If you can explain the relationship of ext3 and other filesystems with =
this=20
> bug, please reply keeping the CC:
>=20
> Thank you,
> Ulrich




--=__PartD7E4851A.0__=
Content-Type: application/octet-stream; name="Header"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="Header"

UmV0dXJuLXBhdGg6IDw+DQpSZWNlaXZlZDogZnJvbSBycnptdGEyLnVuaS1yZWdlbnNidXJnLmRl
IChsb2NhbGhvc3QgWzEyNy4wLjAuMV0pDQoJYnkgbG9jYWxob3N0IChQb3N0Zml4KSB3aXRoIFNN
VFAgaWQgMDFFMUE0M0YwMQ0KCWZvciA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IEZy
aSwgMTYgQXVnIDIwMTMgMTA6Mjk6MzUgKzAyMDAgKENFU1QpDQpSZWNlaXZlZDogZnJvbSBnd3Nt
dHAxLnVuaS1yZWdlbnNidXJnLmRlIChnd3NtdHAxLnVuaS1yZWdlbnNidXJnLmRlIFsxMzIuMTk5
LjUuNTFdKQ0KCWJ5IHJyem10YTIudW5pLXJlZ2Vuc2J1cmcuZGUgKFBvc3RmaXgpIHdpdGggRVNN
VFAgaWQgRDI1NjQ0M0VGRA0KCWZvciA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IEZy
aSwgMTYgQXVnIDIwMTMgMTA6Mjk6MzQgKzAyMDAgKENFU1QpDQpSZWNlaXZlZDogZnJvbSB1bmkt
cmVnZW5zYnVyZy1zbXRwMS1NVEEgYnkgZ3dzbXRwMS51bmktcmVnZW5zYnVyZy5kZQ0KCXdpdGgg
Tm92ZWxsX0dyb3VwV2lzZTsgRnJpLCAxNiBBdWcgMjAxMyAxMDoyOToxNSArMDIwMA0KTWVzc2Fn
ZS1JZDogPDUyMERGRjBCMDIwMDAwQTEwMDAxMjQxMkBnd3NtdHAxLnVuaS1yZWdlbnNidXJnLmRl
Pg0KWC1NYWlsZXI6IE5vdmVsbCBHcm91cFdpc2UgSW50ZXJuZXQgQWdlbnQgMTIuMC4yIA0KRGF0
ZTogRnJpLCAxNiBBdWcgMjAxMyAxMDoyOTozMSArMDIwMA0KRnJvbTogIlVscmljaCBXaW5kbCIg
PFVscmljaC5XaW5kbEByei51bmktcmVnZW5zYnVyZy5kZT4NClRvOiA8bGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZz4NCkNjOiAiVWxyaWNoIFdpbmRsIiA8VWxyaWNoLldpbmRsQHJ6LnVuaS1y
ZWdlbnNidXJnLmRlPg0KU3ViamVjdDogUTogIE5GUzogZGlyZWN0b3J5IFhYWC9ZWVkgY29udGFp
bnMgYSByZWFkZGlyIGxvb3AuUGxlYXNlDQogY29udGFjdCB5b3VyIHNlcnZlciB2ZW5kb3IuDQpN
aW1lLVZlcnNpb246IDEuMA0KQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PVVTLUFT
Q0lJDQpDb250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiBxdW90ZWQtcHJpbnRhYmxlDQpDb250ZW50
LURpc3Bvc2l0aW9uOiBpbmxpbmUNCg==

--=__PartD7E4851A.0__=--
