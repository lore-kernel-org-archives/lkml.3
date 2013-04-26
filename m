Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3DZLzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:55:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab3DZLzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:55:45 -0400
Message-ID: <517A6B3F.6060000@suse.cz>
Date: Fri, 26 Apr 2013 13:55:43 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: sedat.dilek@gmail.com
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 26
References: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au> <CA+icZUWt_W5FUQgQ2TFoQU0df+sAbxZZE8AcD16T3f_fiTD9DQ@mail.gmail.com> <517A4FC1.3070605@suse.cz> <20130426100435.GA28733@sepie.suse.cz> <CA+icZUVOfB2JuL1xh1EO1hTP_eOkntYFKsUJ0Zp6VZqn09NABA@mail.gmail.com> <CA+icZUWNVEsiTs6u_2R9krb45ub4t-pZj_VEPRmrX2c4DzwfmA@mail.gmail.com> <CA+icZUXSsqN1iE3ttQakvpZqG-oOL9NR6RMUezB7LGeUw3d00Q@mail.gmail.com> <517A6033.5060103@suse.cz> <517A615D.9020400@suse.cz> <CA+icZUWiZZDq1NsK9K9_dp0624ytU9n5Z49UmwONdM4M9jAt=A@mail.gmail.com> <CA+icZUVUPCU_pZBJeVNAGsF1rYLH=eCTig11fh=5i7RXdehMFA@mail.gmail.com>
In-Reply-To: <CA+icZUVUPCU_pZBJeVNAGsF1rYLH=eCTig11fh=5i7RXdehMFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.4.2013 13:45, Sedat Dilek wrote:
> On Fri, Apr 26, 2013 at 1:23 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Fri, Apr 26, 2013 at 1:13 PM, Michal Marek <mmarek@suse.cz> wrote:
>>> On 26.4.2013 13:08, Michal Marek wrote:
>>>> On 26.4.2013 12:49, Sedat Dilek wrote:
>>>>> With reverting all kbuild-next commits I was able to build again.
>>>>>
>>>>>       Revert "kconfig: implement KCONFIG_PROBABILITY for randconfig"
>>>>>       Revert "kconfig: allow specifying the seed for randconfig"
>>>>>       Revert "kconfig: fix randomising choice entries in presence of
>>>>> KCONFIG_ALLCONFIG"
>>>>>       Revert "kconfig: do not override symbols already set"
>>>>>       Revert "kconfig: fix randconfig tristate detection"
>>>>
>>>> I did the same, then applied all the kconfig commits once more and did a
>>>> git bisect with this script:
>>>>
>>>> #!/bin/sh
>>>>
>>>> cp config-bad .config
>>>> make silentoldconfig </dev/null
>>>>
>>>> This resulted in
>>>>
>>>> 7ded2624f8988bd22819a60a6000ba6b7091db89 is the first bad commit
>>>> commit 7ded2624f8988bd22819a60a6000ba6b7091db89
>>>> Author: Yann E. MORIN <yann.morin.1998@free.fr>
>>>> Date:   Sun Mar 10 16:34:10 2013 +0100
>>>>
>>>>     kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
>>>>
>>>> The commit id is different, because it is reverted and applied again. Yann?
>>>
>>> Commit 422c809 ("kconfig: fix randomising choice entries in presence of
>>> KCONFIG_ALLCONFIG") reverts cleanly and reverting it fixes the bug. So
>>> there is a plan B.
>>>
>>
>> Thanks for your efforts!
>>
> 
> Feel free to add my...
> 
>      Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

Well, I hope that Yann will come up with a proper fix. He is usually
online during evening hours (+0200), so let's wait some time. Of course,
the fallback is to apply the revert and then I will add your Tested-by.

Michal
