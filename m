Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3EVAvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:51:24 -0400
Received: from intranet.asianux.com ([58.214.24.6]:46804 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3EVAvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:51:23 -0400
X-Spam-Score: -100.8
Message-ID: <519C1658.3040209@asianux.com>
Date: Wed, 22 May 2013 08:50:32 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: kernel: need extern variable 'screen_info' for
 related driver using.
References: <5199B7D6.40907@asianux.com> <20130520091008.GB31359@mudshark.cambridge.arm.com> <519AE6D7.1090401@asianux.com> <CAMuHMdWNHPDkf35MYMKnxt5pn3a+dsT4jgYxuuHrp+mpZMckfw@mail.gmail.com> <519B278B.6030708@asianux.com> <20130521090336.GC10453@mudshark.cambridge.arm.com> <519B48B4.6050607@asianux.com> <20130521131539.GC27002@arm.com>
In-Reply-To: <20130521131539.GC27002@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 09:15 PM, Catalin Marinas wrote:
> On Tue, May 21, 2013 at 11:13:08AM +0100, Chen Gang wrote:
>> > On 05/21/2013 05:03 PM, Will Deacon wrote:
>>> > > On Tue, May 21, 2013 at 08:51:39AM +0100, Chen Gang wrote:
>>>> > >> For me, I still recommend add 'ARM64' in the long list of architectures
>>>> > >> for 'VGA_CONSOLE', I have 3 reasons, please check:
>>>> > >>
>>>> > >> a. current implementation only changes one area which only related with
>>>> > >> arm64 and 'VGA_CONSOLE', but if use 'CONFIG_HAVE_VGA_CONSOLE', that will
>>>> > >> touch many multiple platforms dependency, at least we need discuss about
>>>> > >> it with multiple platforms guys for it, firstly.
>>> > > 
>>> > > That's a weak argument. You might as well propose the cleanup and see what
>>> > > people say.
>> > 
>> > Hmm.. I think at least, we need discuss it with the 'final applier'
>> > firstly (and now, I even do not know who is the 'final applier').
> Well, you can post the patch to linux-arch, cc'ing the arch maintainers
> whose Kconfig files you touch. If there are no comments, it will most
> likely be picked by Andrew Morton and sent to Linus (make sure you cc
> Andrew as well).

OK, thanks. I will do with PARPORT_PC firstly, I think, it is a better
candidate than VGA_CONSOLE.

And excuse me, I have to do another things now, and I think I should
finish the PARPORT_PC within this week.


Thanks.
-- 
Chen Gang

Asianux Corporation
