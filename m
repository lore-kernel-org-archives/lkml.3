Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaGGP1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:27:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:50444 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaGGP1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:27:42 -0400
Date: Mon, 7 Jul 2014 17:27:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 10/11] qspinlock: Paravirt support
Message-ID: <20140707152734.GX6758@twins.programming.kicks-ass.net>
References: <20140615124657.264658593@chello.nl>
 <20140615130154.213923590@chello.nl>
 <20140620134608.GA11545@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B1+FeH9/zg1Fgdnk"
Content-Disposition: inline
In-Reply-To: <20140620134608.GA11545@laptop.dumpdata.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B1+FeH9/zg1Fgdnk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 20, 2014 at 09:46:08AM -0400, Konrad Rzeszutek Wilk wrote:
> I dug in the code and I have some comments about it, but before
> I post them I was wondering if you have any plans to run any performance
> tests against the PV ticketlock with normal and over-committed scenarios?

I can barely boot a guest.. I'm not sure I can make them do anything
much at all yet. All this virt crap is totally painful.


--B1+FeH9/zg1Fgdnk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTurxmAAoJEHZH4aRLwOS6V8kP/2/wBt9lbzbfHPE65HZV/Gk0
vSJ6u+u0ZL3rqRqBkVCRF/YTeg7bE+LSMcR6ZuWwouWvjpzoJyWoNCwUNk62RUr+
pITOJhkQ5ZWOsnjsaA7M6WAJyjQBf8MKK2aquNVO5MxOFShiRmjw5COz/MkBGs9Y
25KKiNaoO+3+/FSUiTPD56XaatUf6tcepG1W0vD08lswZk07HAlGEYX13NZlxMo/
+4YoSxzrcjouShTzSJuLn/WYcVTETVnq9RBmnpBzpEhhAd1ZsQAT9uv1WaUc/f25
bCAvv3rFCnj+UxZkuE8RNp4bPAoxq1VBcFyF+rPnZD13Kxs7CiLI9kxRvNWM2u8x
bQi952q1tUVMSfskl6SrOZ9i16r42f42YkVJMOhDolDBCadknTrczBOQkvC59EkJ
fGI35n0qPfvmhH4cw08lQ4WYAmdIX+snpmIswSJWjWgpHYqldTIHMKIRAfOgQvRa
TVqvzdKNc+Oe28dxDZFsXCGMM8kW8Kx2zPst6+jpzjMQ6k6MVBy+9Iwtr9yChhYy
QsWzTvHOvBC3C5buow3ohOukxedIgG/vckhYRqzkgYPfjXtx+WuycqykYKIb68Lt
+zvmGb76j8VZaVsCWylllEaQ81EL+esw5E9Wlw1lIY2yv9j9uItjWpIgeSqfUUXV
mDvqdGIcLtsltap+YBdV
=00/v
-----END PGP SIGNATURE-----

--B1+FeH9/zg1Fgdnk--
