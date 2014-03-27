Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbaC0PDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:03:35 -0400
Received: from verein.lst.de ([213.95.11.211]:54310 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958AbaC0PDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:03:33 -0400
Date: Thu, 27 Mar 2014 16:03:28 +0100
From: Torsten Duwe <duwe@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        ingo.tuchscherer@de.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>, Greg Price <price@mit.edu>
Subject: Re: [PATCH v2 02/03]: hwrng: create filler thread
Message-ID: <20140327150328.GB18563@lst.de>
References: <20140321142950.GI1763@lst.de> <20140321143342.GK1763@lst.de> <533375C1.5060904@mit.edu> <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com> <CALCETrUa_y6nGAtHmKkMwfTttXEabXCWPsXv==RrJN0_T3imZA@mail.gmail.com> <5333AD63.9030808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5333AD63.9030808@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 09:47:31PM -0700, H. Peter Anvin wrote:
> On 03/26/2014 06:11 PM, Andy Lutomirski wrote:
> > Also, in the /dev/random sense,
> > most hardware RNGs have no entropy at all, since they're likely to be
> > FIPS-approved DRBGs that don't have a real non-deterministic source.
> 
> Such a device has no business being a Linux hwrng device.  We already
> have a PRNG (DRBG) in the kernel, the *only* purpose for a hwrng device
> is to be an entropy source.

That's also my understanding. The shot noise from a Schottky-diode seems
to be quite popular, for example.

> TPMs, in particular, should almost certainly be massively derated based
> on what little we know about TPM.

Backdoors, anyone? :-)

	Torsten

