Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaE0NmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:42:07 -0400
Received: from verein.lst.de ([213.95.11.211]:59876 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaE0NmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:42:02 -0400
Date: Tue, 27 May 2014 15:41:56 +0200
From: Torsten Duwe <duwe@lst.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
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
Subject: [PATCH v5 00/03]: hwrng: an in-kernel rngd
Message-ID: <20140527134156.GA14099@lst.de>
References: <20140321142950.GI1763@lst.de> <20140321143342.GK1763@lst.de> <533375C1.5060904@mit.edu> <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com> <20140414160211.GE711@lst.de> <20140414160653.GC29351@lst.de> <CALCETrUmFdrGExKB+tKSMVK1yWAw6KWU1tpgjnoFe=+XhJdtTw@mail.gmail.com> <20140415085126.GA17327@lst.de> <CALCETrXrHOJkEvYv8VGaNNJSFarAaD7E7G7myOvWo5SG4m4qKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXrHOJkEvYv8VGaNNJSFarAaD7E7G7myOvWo5SG4m4qKg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 09:53:53AM -0700, Andy Lutomirski wrote:
> On Tue, Apr 15, 2014 at 1:51 AM, Torsten Duwe <duwe@lst.de> wrote:
> > You're right. Would anyone object to call it "quality", as in RX signal quality?
> > In context of a random source that is pretty accurate, I'd say. Other opinions?
> 
> I'm okay with "quality", although I'm still partial to "entropy_per_1000bits".

So, since there were no other comments, here's v5 with aforementioned change.
Default is still "off". Patch 02/03 de-fuzzed for 3.15.

	Torsten

