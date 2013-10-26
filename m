Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3JZCOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 22:14:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9795 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3JZCOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 22:14:07 -0400
X-Spam-Score: -100.9
Message-ID: <526B252F.2050506@asianux.com>
Date: Sat, 26 Oct 2013 10:13:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arc: kernel: add default extern variable 'screen_info'
 in "setup.c"
References: <5267AE7D.4080600@asianux.com> <C2D7FE5348E1B147BCA15975FBA23075152B30@IN01WEMBXA.internal.synopsys.com> <52688C42.3030907@asianux.com> <CAMuHMdWD1ENyrBMimnoYQc4hzJ_Zkob-1RQ3F+wXbSktYcO9xQ@mail.gmail.com> <5269032E.2060400@asianux.com> <CAMuHMdWCrLaAiOtgKtH5yb82XvoDJ15BEUB8gyQS2-CkjQqHTw@mail.gmail.com>
In-Reply-To: <CAMuHMdWCrLaAiOtgKtH5yb82XvoDJ15BEUB8gyQS2-CkjQqHTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 07:51 PM, Geert Uytterhoeven wrote:
> Hi Chen,
> 
> On Thu, Oct 24, 2013 at 1:23 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>> Lot's of negative dependencies are missing for VGA_CONSOLE.
>>> I think only alpha, some arm, ia64, some mips, some powerpc, and x86
>>> may use it.
>>>
>>
>> in "arch" sub-directory, contents 13/30 (43.3%) architectures contents
>> VGA_CONSOLE.
>>
>>   1 alpha/kernel/setup.c:137:struct screen_info screen_info = {
>>   2 arm/kernel/setup.c:743:struct screen_info screen_info = {
>>   3 cris/kernel/setup.c:28:struct screen_info screen_info;
>>   4 ia64/kernel/setup.c:79:struct screen_info screen_info;
>>   5 m32r/kernel/setup.c:55:struct screen_info screen_info = {
>>   6 mips/kernel/setup.c:43:struct screen_info screen_info;
>>   7 powerpc/kernel/setup-common.c:88:struct screen_info screen_info = {
>>   8 score/kernel/setup.c:37:struct screen_info screen_info;
>>   9 sh/kernel/setup.c:68:struct screen_info screen_info;
>>  10 sparc/kernel/setup_64.c:66:struct screen_info screen_info = {
>>  11 sparc/kernel/setup_32.c:53:struct screen_info screen_info = {
>>  12 tile/kernel/setup.c:54:struct screen_info screen_info;
>>  13 x86/kernel/setup.c:220:struct screen_info screen_info;
>>  14 xtensa/kernel/setup.c:55:struct screen_info screen_info = { 0, 24, 0, 0, 0, 80, 0, 0, 0, 24, 1, 16};
>>
>> It seems most of pc and servers support VGA_CONSOLE.
> 
> I'm quite sure many of these just provide a screen_info to make vgacon compile.
> 

Thank you for your confirmation.

>>> Compare this to a shiny new feature that available on all new architectures,
>>> but not on a few old one. There it makes sense to have the negative
>>> dependencies on the old architectures, that will never have the new feature.
>>> While new architectures have enabled it by default.
>>>
>>
>> Excuse me, my English is not quite well, I do not quite understand your
>> meaning, but it seems not quite important for our discussing, so I just
>> skip it, now.
> 
> Sorry, I should stop writing complex sentences.
> For now, nevermind. There aren't that many real cases like this.
> 

And I should be still improving my English. :-)

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
> 

Thanks.
-- 
Chen Gang
