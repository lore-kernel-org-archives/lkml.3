Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaIVVv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:51:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:50666 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbaIVVvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:51:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,574,1406617200"; 
   d="asc'?scan'208";a="479276808"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
Subject: Re: [PATCH] sched: Remove nested extern
Thread-Topic: [PATCH] sched: Remove nested extern
Thread-Index: AQHP1o5n4j/Km9jR6U6Rx5Rq0DoBGpwN93YAgAAIi4CAAAlVgIAADxwAgAAGBoCAAAhHgA==
Date: Mon, 22 Sep 2014 21:50:44 +0000
Message-ID: <9C9DCC69-1F75-4241-A022-FFB9B6A11AC5@intel.com>
References: <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
 <20140922175511.62229.98784.stgit@mdrustad-wks.jf.intel.com>
 <20140922190128.GA2805@worktop.programming.kicks-ass.net>
 <D428C53D-F663-4846-ACAB-74922033B048@intel.com>
 <20140922200527.GA3128@worktop.programming.kicks-ass.net>
 <D3423D3A-814F-4E22-A84B-61D76D137A98@intel.com>
 <20140922212105.GD3128@worktop.programming.kicks-ass.net>
In-Reply-To: <20140922212105.GD3128@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.145]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_18D117C2-F9E5-459C-A416-EC76765E82F7";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_18D117C2-F9E5-459C-A416-EC76765E82F7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 22, 2014, at 2:21 PM, Peter Zijlstra <peterz@infradead.org> =
wrote:

> On Mon, Sep 22, 2014 at 08:59:32PM +0000, Rustad, Mark D wrote:
>> Because I have found that enabling many warnings helps identify =
problems
>> in code and it has been my standard practice since about 1999 to do =
so.
>> The compiler warnings are really just another form of static =
analysis,
>> and I use it routinely on every compile. Here is how routinely: I =
have
>> W=3D1 in my environment, W=3D12 is just too painful. I would change =
that
>> default to W=3D12 if it wasn't insane to do so.
>=20
> Many warnings are just plain insane and stupid. They're not helping
> anybody. There's a very good reason many are disabled. I'm sure you =
can
> find some entertaining discussions on the topic if you search the LKML
> archives.

That is what I used to think. -Wshadow for example. What's the problem? =
It
is perfectly valid C. Well, I recently sent a patch that changed some
function parameters that used the name jiffies, which of course shadowed
the well-known global. If a macro were ever called in those functions
whose expansion ever tried to access jiffies, well it wouldn't do what
was expected. Not a bug now, but a trap for the future. I only found =
that
because I either resolved or silenced enough warnings to see something =
interesting.

Over the years I think I have resolved real bugs revealed by probably =
nearly
every one of the additional warning messages. They do have value, but =
that
value is typically lost if the norm is a flood of messages. Apple would =
not
have had their SSL problem if they had had -Wunreachable-code enabled =
and
noticed the message.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_18D117C2-F9E5-459C-A416-EC76765E82F7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUIJm0AAoJEDwO/+eO4+5u1P8QAKfPs62HndTh+iCaza7BwvwH
6grUaidMoTs2DHPAM1/krZGB0s+TVKqvmlp3YL2QN+JX9qFxLmDyuSILQedJ1kO0
1mw/XTrLiS3g9ZFdM70R3yIPOc2FyiidbE4h5tjqw8GSa8MXpXu52Zv7YKpXDeAe
R3FV5AzWV6Gcq1NGwtKqG1tx79ebkXclDd5KIPQ4N291S+iv7+VDMH1dN5RpShmJ
+d+OieprfIdF+d2vLMQHfrYALyzsmvGzLGDpK6NV7N4V6CHTCNJwagogyM7ZT9kW
YQ9KBkZOiWtGseY2pShoFXMmfJjfbwhECkKNWbajMk9gCM9RYeqlkJm8z3QHReZA
jtU0WrBtmBqZEA/TDv8/fKK3SyE2FRSx97kw/5CAgiKp5B15/UE9tU0wAxt5Aqnn
VpQ9B3EBQY93T9eOA67svqvDpK7BEFXDKeYtl1u3/Gc5PNGT10/Smx3y9utykGZl
rbctZVZga3Jr8nVE4Qt4cdmFvWRdwoFAaEjQOuzIpMKcaP2/G2s8YUbE2E6jpQXA
vbsXMkHllcmkYq3hQ+4TQG9DsulcVQHUeYv2NK8F9Q6u6NN6992l/ypAJnxfNJ34
O+XA7vMFr/13elkdIdID5dwJeyBcHnsaRJr2fem74PEUv6fFZQYPZhF+dgWPwKVx
b8AP1mz0xoTqF0NmjPep
=scE2
-----END PGP SIGNATURE-----

--Apple-Mail=_18D117C2-F9E5-459C-A416-EC76765E82F7--
