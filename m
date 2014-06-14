Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbaFNCpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 22:45:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55238 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbaFNCpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 22:45:17 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140614024050.GA6447@thunk.org>
References: <20140414160211.GE711@lst.de> <20140414160653.GC29351@lst.de> <CALCETrUmFdrGExKB+tKSMVK1yWAw6KWU1tpgjnoFe=+XhJdtTw@mail.gmail.com> <20140415085126.GA17327@lst.de> <CALCETrXrHOJkEvYv8VGaNNJSFarAaD7E7G7myOvWo5SG4m4qKg@mail.gmail.com> <20140527134156.GA14099@lst.de> <20140527134645.GD14099@lst.de> <20140527141144.GE14099@lst.de> <53990165.3070505@zytor.com> <20140612100954.GA26943@lst.de> <20140614024050.GA6447@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [Patch v5.1 03/03]: hwrng: khwrngd derating per device
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 13 Jun 2014 19:44:08 -0700
To: "Theodore Ts'o" <tytso@mit.edu>, Torsten Duwe <duwe@lst.de>
CC: Andy Lutomirski <luto@amacapital.net>,
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
Message-ID: <26a6d3cf-d327-4089-bdef-f48d3163e3bc@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes sense to me.

Feel free to add my

Acked-by: H. Peter Anvin <hpa@zytor.com>

On June 13, 2014 7:40:50 PM PDT, Theodore Ts'o <tytso@mit.edu> wrote:
>On Thu, Jun 12, 2014 at 12:09:54PM +0200, Torsten Duwe wrote:
>> > 
>> > Did we lose track of this patchset?
>> 
>> Yes. I was already considering a resend.
>
>I've looked it over, and I'm fairly OK with it at this point.  Do
>folks mind if I just run it through the random tree?
>
>I want to add a tracepoint for better debugging, but I can take care
>of that after it's in the random tree.
>
>						- Ted

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
