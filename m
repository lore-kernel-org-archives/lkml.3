Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3KGIqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:46:49 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:38289 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab3KGIqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:46:42 -0500
MIME-Version: 1.0
In-Reply-To: <20131107073438.GA26654@gmail.com>
References: <527B28BB.9070400@infradead.org>
	<20131107073438.GA26654@gmail.com>
Date: Thu, 7 Nov 2013 09:46:40 +0100
Message-ID: <CADyApD25k63K1t9SXv7EERopk3sCE9Wq65fiGiFAn_zuPHsd5Q@mail.gmail.com>
Subject: Re: kernel bugzilla #64531: intel microcode information
From: Arjan van de Ven <arjanvandeven@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fwiw this file lives on intel.com for a while now.. unfortunately it's
one of these websites with fancy downloading stuff for which I suspect
the URLs are not long term stable ;-(
but if you type "microcode" into the search box its the first entry...

On Thu, Nov 7, 2013 at 8:34 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Randy Dunlap <rdunlap@infradead.org> wrote:
>
>> Re: https://bugzilla.kernel.org/show_bug.cgi?id=64531
>>
>>
>> arch/x86/Kconfig line 1053 (+/-), help section in CONFIG_MICROCODE_INTEL, says:
>>
>> For latest news and information on obtaining all the required
>> Intel ingredients for this driver, check:
>> <http://www.urbanmyth.org/microcode/>
>>
>> ==> 404  Page not found
>>
>>
>> Is there a good replacement for this information or should we just
>> delete that help text?
>
> I'd say let's delete the text. Mind sending a patch?
>
> Thanks,
>
>         Ingo
