Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaFNClL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 22:41:11 -0400
Received: from imap.thunk.org ([74.207.234.97]:38553 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbaFNClJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 22:41:09 -0400
Date: Fri, 13 Jun 2014 22:40:50 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Torsten Duwe <duwe@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
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
Message-ID: <20140614024050.GA6447@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Torsten Duwe <duwe@lst.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Satoru Takeuchi <satoru.takeuchi@gmail.com>,
	ingo.tuchscherer@de.ibm.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hans-Georg Markgraf <MGRF@de.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Joe Perches <joe@perches.com>
References: <20140414160211.GE711@lst.de>
 <20140414160653.GC29351@lst.de>
 <CALCETrUmFdrGExKB+tKSMVK1yWAw6KWU1tpgjnoFe=+XhJdtTw@mail.gmail.com>
 <20140415085126.GA17327@lst.de>
 <CALCETrXrHOJkEvYv8VGaNNJSFarAaD7E7G7myOvWo5SG4m4qKg@mail.gmail.com>
 <20140527134156.GA14099@lst.de>
 <20140527134645.GD14099@lst.de>
 <20140527141144.GE14099@lst.de>
 <53990165.3070505@zytor.com>
 <20140612100954.GA26943@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612100954.GA26943@lst.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 12:09:54PM +0200, Torsten Duwe wrote:
> > 
> > Did we lose track of this patchset?
> 
> Yes. I was already considering a resend.

I've looked it over, and I'm fairly OK with it at this point.  Do
folks mind if I just run it through the random tree?

I want to add a tracepoint for better debugging, but I can take care
of that after it's in the random tree.

						- Ted
