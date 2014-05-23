Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaEWQiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:38:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39987 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbaEWQiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:38:21 -0400
Message-ID: <537F78EA.3070508@zytor.com>
Date: Fri, 23 May 2014 09:35:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 16/18] x86: io: implement dummy relaxed accessor macros
 for writes
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>	<1400777250-17335-17-git-send-email-will.deacon@arm.com>	<537E30AF.4070501@zytor.com>	<20140523144604.GF21319@arm.com>	<537F60E0.1060307@zytor.com>	<20140523145758.GG21319@arm.com>	<537F6728.3090600@zytor.com>	<20140523153409.GI21319@arm.com>	<537F6C85.107@zytor.com>	<20140523155626.GI30445@twins.programming.kicks-ass.net> <CAMuHMdW2rVvcORs6tbChxKVoVUnq0j8cfJa+GY6XH_=Tfr+Xcw@mail.gmail.com>
In-Reply-To: <CAMuHMdW2rVvcORs6tbChxKVoVUnq0j8cfJa+GY6XH_=Tfr+Xcw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 09:31 AM, Geert Uytterhoeven wrote:
> On Fri, May 23, 2014 at 5:56 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> So the one issue I had with that, is that if one tries to send an email
>> to all arch maintainers + linux-arch + linux-kernel, the header gets too
>> big and vger chokes and davem slaps you.
> 
> The arch maintainers are (supposed to be) on linux-arch.
> 

That doesn't mean we read it in real time like something that comes into
our main inbox.  The messed-up context is annoying.

	-hpa


