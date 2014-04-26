Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaDZRVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 13:21:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48846 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbaDZRVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 13:21:13 -0400
Message-ID: <535BEAF9.9050202@gentoo.org>
Date: Sat, 26 Apr 2014 13:20:57 -0400
From: Richard Yao <ryao@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf machine: Search for modules in %s/lib/modules/%s
References: <1397148779-9169-1-git-send-email-ryao@gentoo.org> <871twztacr.fsf@sejong.aot.lge.com> <20140415115629.GF1700@krava.brq.redhat.com>
In-Reply-To: <20140415115629.GF1700@krava.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="UUmhJWhWC1lJTOqkemtvfghCN9TDRkrTA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UUmhJWhWC1lJTOqkemtvfghCN9TDRkrTA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dear Jirka,

I have sent an updated patch, but instead of using your white list idea,
I went with a black list. That way things like the historical addon
directory are included and anyone who decides to use a custom directory
for their own in-development modules is free to do so.

Yours truly,
Richard Yao

On 04/15/2014 07:56 AM, Jiri Olsa wrote:
> On Tue, Apr 15, 2014 at 02:44:52PM +0900, Namhyung Kim wrote:
>> Hi Richard,
>>
>> On Thu, 10 Apr 2014 12:52:59 -0400, Richard Yao wrote:
>>> Modules installed outside of the kernel's build system should go into=

>>> "%s/lib/modules/%s/extra", but at present, perf will only look at the=
m
>>> when they are in "%s/lib/modules/%s/kernel". Lets encourage good
>>> citizenship by relaxing this requirement to "%s/lib/modules/%s". This=

>>> way open source modules that are out-of-tree have no incentive to sta=
rt
>>> populating a directory reserved for in-kernle modules and I can stop =
hex
>>> editing my system's perf binary when profiling OSS out-of-tree module=
s.
>>
>> But it'll make the perf traverses all the source and build directories=

>> too, right?  I don't think it's a right thing to do.
>>
>> Maybe we can also change stat() in map_groups__set_modules_path_dir() =
to
>> lstat() so that it cannot go to unwanted directories in that case.  Or=

>> else, just checking "kernel" and "extra" directories will work.
>=20
> yay, forgot about source directory.. :-\  looks like lstat should
> help, but hardcoding kernel and extra sounds better to me.
>=20
> Richard, please send updated patch
>=20
> thanks,
> jirka
>=20



--UUmhJWhWC1lJTOqkemtvfghCN9TDRkrTA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTW+r+AAoJECDuEZm+6ExkQyMQAIeqc2HUoACNI+E9gUD3UC0r
TNxASfYp2M8ShKg4e7x4IT5HKPen0YlxVPKhzo4e+j5ThfXwnl9HVxCAnYG+/gki
eaa3MXI29MJ6/UxSDcTZn5Lu2xuRRE5VVyuoCkvoj0VViCbBOX1+bdVXHkqZX5Jp
73zyNsTfs06TuPTSI7jMBL3sXhlfE7VeAs+2n+bPCCgzRRlTSsalnBS7+tv1QURd
sw80Hb+CnYXFuI+eOLuCCCrJiACjzZVBmFjYZv1UWn0F7VuPxMDbN9f/Eyz8J2e+
HEW+uBClmuBgxcM7ifAnUki9SGv95+78BgcjMvMcWsRDHIRkA0yML+E+PsEB9xBz
STSjmNPPC78gbKUD5llW2QGZvIqOb6dpz+gvUiFNhHilR1fTNlNTExxAeh5nGTu6
cBGcQhSqrG/RU++STAgudsf1xf/71tfJ6TD4sN4ZTG5C02zR7eZrw0RPs7YC6m1I
lpYm1fYWNtN6DveRlMWBU6BV2Ff6gi61mWwckqveIW84+2YZgAxhysF4nRzfEHk6
Fw+1cRRWcQbOjPY7x+sLevUGmrkwhuaAmw8lWEOXs0R3frFRu5RFopJLMhhh4pG3
zVLLeAzL2sLXrPagKe9tW/slyJlO81utOqgUmbJGKebYhubTFFmr7dHz4v0aoBG5
3WlWH8+3bnXz7TkCQ73F
=RSMJ
-----END PGP SIGNATURE-----

--UUmhJWhWC1lJTOqkemtvfghCN9TDRkrTA--
