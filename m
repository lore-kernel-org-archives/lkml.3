Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3LFCBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:01:12 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50955 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3LFCBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:01:09 -0500
Message-ID: <52A1305B.8060009@gmail.com>
Date: Fri, 06 Dec 2013 10:03:07 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rkuo <rkuo@codeaurora.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arc: kernel: add default extern variable 'screen_info'
 in "setup.c"
References: <529707B9.1090809@gmail.com> <20131206005829.GA7615@codeaurora.org>
In-Reply-To: <20131206005829.GA7615@codeaurora.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 08:58 AM, rkuo wrote:
> On Thu, Nov 28, 2013 at 05:07:05PM +0800, Chen Gang wrote:
>> Hello Vineet:
>>
>> hexagon meets the same issue, could you help send related patch for it?
>>
>> If you have no time, please let me know, I should send it within next
>> month.
>>
>> BTW: I assume hexagon need not support VGA_CONSOLE, either, if it is
>> incorrect, please let me know thanks.
>>
>>
> 
> Just to chime in on this one, Hexagon probably won't have the hardware,
> but we would still like to be able to compile the code, so I will fix this
> in Hexagon's arch tree.
> 

Thank you very much.


-- 
Chen Gang

Open, share, and attitude like air, water and life which God blessed
