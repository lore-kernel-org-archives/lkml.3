Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaCYIY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:24:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52797 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaCYIYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:24:21 -0400
Message-ID: <53313D09.7000605@canonical.com>
Date: Tue, 25 Mar 2014 09:23:37 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
References: <52FCFA23.4060701@canonical.com> <20140213173852.GH6835@laptop.programming.kicks-ass.net> <52FD090C.7010408@canonical.com> <20140213182605.GC14089@laptop.programming.kicks-ass.net> <20140214133428.GB26356@pd.tnic> <52FE2709.3050505@canonical.com> <20140214144700.GC26356@pd.tnic> <52FE4C28.1080500@canonical.com> <20140214172157.GJ6835@laptop.programming.kicks-ass.net> <53062165.3040202@canonical.com> <20140220155041.GG9987@twins.programming.kicks-ass.net> <53306DD8.8020002@redhat.com>
In-Reply-To: <53306DD8.8020002@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Vsfrx4BVLBVrjmgOLudktagLRVPN2Pb5F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Vsfrx4BVLBVrjmgOLudktagLRVPN2Pb5F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 24.03.2014 18:39, Paolo Bonzini wrote:
> Il 20/02/2014 16:50, Peter Zijlstra ha scritto:
>>>>> > >> One thing I likely should do is to reinstall the exact same la=
ptop
>>>>> with 64bit
>>>>> > >> kernel and userspace... maybe only 64bit kernel first... and m=
ake sure
>>>>> on my
>>>>> > >> side that this does not show up on 64bit, too. I took the word=
 of
>>>>> reporters for
>>>>> > >> that (and the impression that otherwise many more people would=
 have
>>>>> complained).
>>>> > >
>>>> > > Yeha, I'm going to try and install some 32bit userspace on a usb=

>>>> > > harddisk I've got and see if I can boot my Core2 laptop from tha=
t to try
>>>> > > and reproduce.
>>>> > >
>>>> > > But all that is probably going to be Monday :/
>>>> > >
>>> > *sigh* Already Thursday...
>>> >
>>> > Peter, did you get to reproduce this locally? Unfortunately I had s=
ome
>>> > interruption and have not more Information than on last Friday (whi=
ch is that
>>> > the same hw but 64bit kernel does not show it).
>> I got side-tracked as well, someone reported crashes, which come above=

>> weird behaviour :/
>>
>=20
> Stefan, Peter, any news here?
>=20
> Paolo

No, unfortunately not. :( I thought I had some idea as i386 seems to have=
 soft
and hard irqs using a seperate stack and thought they maybe loose the pro=
cess
flag there (x86_64 seems to always do that for soft irqs and if it does f=
or hard
irqs it was hidden well enough for me not to see). But trial and error sh=
owed
showed no improvement when I made a copy of the original TIF_NEED_RSCHED =
before
executing on stack. So not really any further.
And then the usual distractions hit...

-Stefan


--Vsfrx4BVLBVrjmgOLudktagLRVPN2Pb5F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTMT0VAAoJEOhnXe7L7s6jGo4P/jvs5Ni9oD3RJ+lLFUQZ+1wv
azh8SaHtk64K6vx7uvLfQLsMyQxc4ytgQQjObEDTbDw8uFp1+xdm7W8lhzizpxUO
n0bzL3AaDSt2QXnA4zXnWBTSU+mRNYjqeny5iPQUVHsBr9IVwQc80fjswOPOmosj
Yp+g3SGmdVfSZ8uFfXO5s+JqXpw0VxTrNvsD93AiHhxOamUeAJNYyf+HBtJlERfb
iNNwGdGPjyLhebYGkwudQdGw1nttrNi5Q5uIY/ePgQ41H4XEH3lSZ4ws1m3FsLLn
N1TbLLE8iwz14qo5gYfYCi+HZqxYh/DI+pXgNbHdKU3bqciwFirPQmK4ws1jryJV
iuRZHmlvY/34dD+oYxCnLScoqdBoCpNn+bAnuFWpK15lAqSVOHOFIuDvO5cgH0W5
uCETj0jc+tvC1B9jc495pBFdr9NHWSUkacaGvXINvw2TWSAhuMPhrwAnEvcbhR3O
Nj0nGCn58o2PtXwqNbapiPqlbqJrOK3lhGRIoK58FN/ACStGPsDFxZi6snwQklsL
rjSD9QALaIsUSe/puvhyexpO8I4lEUuynGg3uKz+fkGzgsHAwd8wQD/Z03g9iIqJ
Ik4zBwCosMfIZSD75sMiX2Diu2rQd+QEaGSxUm9+T5naI+3HgLwtINMvStiqyGMe
oDreGp9KNBwmCY9ilP35
=YbO3
-----END PGP SIGNATURE-----

--Vsfrx4BVLBVrjmgOLudktagLRVPN2Pb5F--
