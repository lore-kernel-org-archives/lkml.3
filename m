Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaHOOln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:41:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:54544 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaHOOlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:41:40 -0400
Date: Fri, 15 Aug 2014 16:41:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ashwin Chaugule <ashwin.chaugule@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Arjan van de Ven <arjan@linux.intel.com>, mingo@kernel.org,
        len.brown@intel.com, rjw@rjwysocki.net,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-acpi@vger.kernel.org,
        cpufreq@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
Message-ID: <20140815144124.GK19379@twins.programming.kicks-ass.net>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
 <20140814205143.GY6758@twins.programming.kicks-ass.net>
 <CAJ5Y-ebgJi8Ngxg1X+h7KMundGZPFhYC0hr0Sog6htj=czszgQ@mail.gmail.com>
 <20140815061917.GX19379@twins.programming.kicks-ass.net>
 <CAJ5Y-eaLxCG7dDao00pozXBL2dxPS7tf=xGfaz3O_xfRHtQZnA@mail.gmail.com>
 <20140815140741.GI19379@twins.programming.kicks-ass.net>
 <CAJ5Y-eZhAX47v4SjsW4T6PUaiMqC9wHcMDS8p+sL4_cReZpbyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="smqHdNbl2cgnTjEa"
Content-Disposition: inline
In-Reply-To: <CAJ5Y-eZhAX47v4SjsW4T6PUaiMqC9wHcMDS8p+sL4_cReZpbyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--smqHdNbl2cgnTjEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2014 at 10:37:32AM -0400, Ashwin Chaugule wrote:
> Hi Peter,
>=20
> On 15 August 2014 10:07, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, Aug 15, 2014 at 09:08:50AM -0400, Ashwin Chaugule wrote:
> >> If the OS only looks at Highest, Lowest, Delivered registers and only
> >> writes to Desired, then we're not really any different than how we do
> >> things today in the CPUFreq layer.
> >
> > The thing is; we're already struggling to make 'sense' of x86 as it
> > stands today. And it looks like this CPPC stuff makes the behaviour even
> > less certain.
>=20
> I think its still better than the "p-state" thing we have going today,
> where the algorithms are making their decisions based on the incorrect
> assumption that the CPU got what it requested for. (among other things
> listed earlier.) CPPC at least gives you a guarantee that the
> delivered performance will be within a range you requested. It can
> even force the platform to deliver a specific performance value if you
> choose over a specific time window.

Maybe; the guarantee and interrupt on change might be useful indeed. But
which ever way we need aperf/mperf ratios somewhere.

--smqHdNbl2cgnTjEa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7hwTAAoJEHZH4aRLwOS60ukP/1IDVKebfOGuHoOA86PFOW2i
37Mb2DkoKjMUZs1das9yySsJJlKtAHfZlIy8Meq32JHT1b0yR6kH1YWhV9lKfnGX
pCov/3HCQj9fCeLisrUcseeNBhw5GScPXtcGxRn7i9BCCVo8w1/QYA14vISqFE29
wQhxhjKmPeHvgcKygmRvRWIIpxQtjoZRUTNa3BHBfwKglgY3lHTatk5WUDwNAoAc
kXvcN0ZFAlP00zwoPTqG2DOqR53F9DJ0ovpFcnh5qJ+vMQts2g8ZDHuur7fXJj/p
DnzoYO97t+dzWsKz3ZGFlprD4fB/BWS4PbJkR5wtNPY7+jfULf+Uu1e0L9nr44Gm
QMd64kS/F/S+O5HTnUOzS3MPYfHg7LMAFG3x+SpzS7/MUitC7xPS6gV6eHVtzAM9
vEITv6GfvJSiLHbdGShx6rRFTAB/Hr4+IOcC+nckBBeAgClmLY2Rqk2bMQWjf+r+
GGTnnAsNZnysh1/77VhraOMMt/D2K6rR+nC2Jo1r1sWvd8bwFRQpzPGKN5cZLNgn
2o9qbXNYxT0XqoWySCIRnvdvMyqz8hirqv5FTB2FvcWdqwdxwEsb3tkgdzzekSZC
iieltKveyfQ3miscpgxcWNrmaza4kKMnpYjSZJ6eii7ZgZwRuVbUDPwcEiFWg2RO
C3VR6yzvxzplK8jSp02k
=qt2F
-----END PGP SIGNATURE-----

--smqHdNbl2cgnTjEa--
