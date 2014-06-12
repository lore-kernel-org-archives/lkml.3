Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaFLBZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:25:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55030 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbaFLBZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:25:35 -0400
Message-ID: <53990165.3070505@zytor.com>
Date: Wed, 11 Jun 2014 18:24:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Torsten Duwe <duwe@lst.de>, Andy Lutomirski <luto@amacapital.net>
CC: "Theodore Ts'o" <tytso@mit.edu>,
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
References: <20140321143342.GK1763@lst.de> <533375C1.5060904@mit.edu> <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com> <20140414160211.GE711@lst.de> <20140414160653.GC29351@lst.de> <CALCETrUmFdrGExKB+tKSMVK1yWAw6KWU1tpgjnoFe=+XhJdtTw@mail.gmail.com> <20140415085126.GA17327@lst.de> <CALCETrXrHOJkEvYv8VGaNNJSFarAaD7E7G7myOvWo5SG4m4qKg@mail.gmail.com> <20140527134156.GA14099@lst.de> <20140527134645.GD14099@lst.de> <20140527141144.GE14099@lst.de>
In-Reply-To: <20140527141144.GE14099@lst.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 07:11 AM, Torsten Duwe wrote:
> [checkpatch tells me not to 0-init...]
> 
> This patch introduces a derating factor to struct hwrng for
> the random bits going into the kernel input pool, and a common
> default derating for drivers which do not specify one.
> 
> Signed-off-by: Torsten Duwe <duwe@suse.de>
> 

Did we lose track of this patchset?

	-hpa


