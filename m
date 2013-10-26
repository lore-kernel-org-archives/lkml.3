Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3JZCMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 22:12:20 -0400
Received: from intranet.asianux.com ([58.214.24.6]:61373 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3JZCMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 22:12:19 -0400
X-Spam-Score: -100.9
Message-ID: <526B24BB.5040709@asianux.com>
Date: Sat, 26 Oct 2013 10:11:07 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arc: kernel: add default extern variable 'screen_info'
 in "setup.c"
References: <5267AE7D.4080600@asianux.com> <C2D7FE5348E1B147BCA15975FBA23075152B30@IN01WEMBXA.internal.synopsys.com> <52688C42.3030907@asianux.com> <CAMuHMdWD1ENyrBMimnoYQc4hzJ_Zkob-1RQ3F+wXbSktYcO9xQ@mail.gmail.com> <5269032E.2060400@asianux.com> <C2D7FE5348E1B147BCA15975FBA23075152ED0@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA23075152ED0@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 07:50 PM, Vineet Gupta wrote:
> On 10/24/2013 04:56 PM, Chen Gang wrote:
>> If what you said is correct, could you help to send related patch for
>> it? if I send this kind of patches, it will be easily redirected to
>> "/dev/null".
> 
> Geert has explained the state of things quite nicely. Please send your patch to
> introduce HAVE_xxx. I'm sure maintainers will respond to it as it is the correct
> thing to do. But I don't want to add bloat to kernel for a random defconfig
> failure which no one will really use for ARC.
> 
> If you think u can't/won't do it - let me know and I'll send the patches instead.
> 

Please help send.

Thanks. :-)

> -Vineet
> 
> 


-- 
Chen Gang
