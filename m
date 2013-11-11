Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3KKCXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 21:23:41 -0500
Received: from ozlabs.org ([203.10.76.45]:40219 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3KKCXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 21:23:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <tom.leiming@gmail.com>, Axel Lin <axel.lin@ingics.com>
Cc: Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
In-Reply-To: <CACVXFVMAnewCkSNNke3kf1-yO+JCc_HBRp8iaLBPJ+14G79Haw@mail.gmail.com>
References: <1383789208.5970.1.camel@phoenix> <CACVXFVMn6RSXchQ8u47F35_J+YSnp1bwF1tr-8uCEYwvFsOfgQ@mail.gmail.com> <CAFRkauAEt-YhBt11opj_GVCLrxGsTSd2LowWGmukTSmGuJkd3A@mail.gmail.com> <CACVXFVO=QA-R1+twCL9fc_3vASg6Ap-3ezi=tU1MV1pdPYrfWw@mail.gmail.com> <CAFRkauAdR3=ByE0_B3OsqOBjmbz2a02EXb+6g-vn=1TJ7AZc8Q@mail.gmail.com> <CACVXFVMaLOfDvzdn_1NryQY59cgtLdMMqHL-_ZAa95MPz4p56Q@mail.gmail.com> <CAFRkauDe7V3N0AbfvE_=GEXHZ_Fw62VsA8p50wSUYE1-TRqMfw@mail.gmail.com> <87zjpf4w0j.fsf@rustcorp.com.au> <CACVXFVNHryPXy2NQhPwXkoCeLUXQSgrWmgBkMNtGD_=X_62_5Q@mail.gmail.com> <CAFRkauDGiy3yZOwKFWMEJvYUe0OoXMEZHKaxogZHdgzMxexdHA@mail.gmail.com> <CACVXFVMAnewCkSNNke3kf1-yO+JCc_HBRp8iaLBPJ+14G79Haw@mail.gmail.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 11 Nov 2013 10:53:23 +1030
Message-ID: <87y54vzszo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <tom.leiming@gmail.com> writes:
> Hi Axel,
>
> On Fri, Nov 8, 2013 at 12:20 PM, Axel Lin <axel.lin@ingics.com> wrote:
>>
>>
>> Hi Ming,
>>
>> I have patches on top of 3.12 to support gpl32700 SoC.
>> So you cannot find this platform on mainline kernel.
>
> OK, I see.
>
>> I havn't tried perf, below is my config for your reference:
>> (to make the config smaller, I grep out disabled config entries.)
>
> I doubt CONFIG_VMSPLIT_3G/CONFIG_PAGE_OFFSET isn't
> used at all in your unmerged patchset, also your link script should
> be different with in-tree arch/arm/kernel/vmlinux.lds.S, otherwise
> you may put all your kernel symbols after 0xC00000000.
>
> Maybe you need to not define PAGE_OFFSET and let it be
> PHYS_OFFSET at default, also VMSPLIT_3G shouldn't have
> been there on non-MMU linux.

OK, unless there are other platforms which have this issue, I'll
leave it with you to hold this patch for merge with your SoC.

Cheers,
Rusty.
