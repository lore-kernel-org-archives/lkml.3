Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaHAWNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:13:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53409 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452AbaHAWNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:13:42 -0400
Message-ID: <53DC10FF.9050704@zytor.com>
Date: Fri, 01 Aug 2014 15:13:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct
 pt_regs"
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com> <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <53DBDDE1.5070805@zytor.com> <CAK1hOcML4guky7VutK1xc3YxNjy4K4bX_78p8+7rEhMW0ZuLdg@mail.gmail.com>
In-Reply-To: <CAK1hOcML4guky7VutK1xc3YxNjy4K4bX_78p8+7rEhMW0ZuLdg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 03:11 PM, Denys Vlasenko wrote:
>>
>> Could you please try to see if there is a measurable change in the
>> latency of a trivial syscall?
> 
> Will do.
> Something along the lines of "how long does it take to execute two
> gazillions of getppid()?"
> 

Something like that, yes, but you have to run enough data points so you
can determine if the difference is statistically significant or just noise.

	-hpa

