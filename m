Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbaFLKKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:10:00 -0400
Received: from verein.lst.de ([213.95.11.211]:44912 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894AbaFLKJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:09:59 -0400
Date: Thu, 12 Jun 2014 12:09:54 +0200
From: Torsten Duwe <duwe@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Joe Perches <joe@perches.com>
Subject: Re: [Patch v5.1 03/03]: hwrng: khwrngd derating per device
Message-ID: <20140612100954.GA26943@lst.de>
References: <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com> <20140414160211.GE711@lst.de> <20140414160653.GC29351@lst.de> <CALCETrUmFdrGExKB+tKSMVK1yWAw6KWU1tpgjnoFe=+XhJdtTw@mail.gmail.com> <20140415085126.GA17327@lst.de> <CALCETrXrHOJkEvYv8VGaNNJSFarAaD7E7G7myOvWo5SG4m4qKg@mail.gmail.com> <20140527134156.GA14099@lst.de> <20140527134645.GD14099@lst.de> <20140527141144.GE14099@lst.de> <53990165.3070505@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53990165.3070505@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 06:24:53PM -0700, H. Peter Anvin wrote:
> On 05/27/2014 07:11 AM, Torsten Duwe wrote:
> > [checkpatch tells me not to 0-init...]
> > 
> > This patch introduces a derating factor to struct hwrng for
> > the random bits going into the kernel input pool, and a common
> > default derating for drivers which do not specify one.
> > 
> > Signed-off-by: Torsten Duwe <duwe@suse.de>
> > 
> 
> Did we lose track of this patchset?

Yes. I was already considering a resend.

	Torsten

