Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaCLXrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 19:47:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:37792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbaCLXrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 19:47:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,642,1389772800"; 
   d="scan'208";a="490864005"
Message-ID: <5320F1F0.5000505@linux.intel.com>
Date: Wed, 12 Mar 2014 16:46:56 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net> <531F365B.4060000@linux.intel.com> <CA+55aFxmkBnwDfKhX7h1qoJ3emD=+ugc3OLNDH79a1kGu7He1Q@mail.gmail.com> <531F3D02.30706@linux.intel.com> <CALCETrXt5=N7U-f1i+oCkbF5xqc0Qn8U_C9B47grcuEagAhDEA@mail.gmail.com> <CALCETrWCXY-hwZh2U4QPp0YeeGuPXFUrUuCn7h-5H+TvdXEq5Q@mail.gmail.com> <CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com> <1394613046.995.51.camel@wall-e.seibold.net> <CA+55aFyTCoipjhbAVCuhCgqb8JeSjGcmOU3xE6EFrjNpfspfqg@mail.gmail.com> <CA+55aFxc8Qp-4_+n=upd-ghzkxpjCyRpesm3P7xtWjDyBe9MCw@mail.gmail.com> <CA+55aFyhS5jCWcxuK4bXKEPh+8HWbPE+gy1m4N9B-2HyT48+QA@mail.gmail.com> <5320D3AB.5060002@linux.intel.com> <CA+55aFzC1Xy1VNF46Mj8V8CEc0tyVA76+631xZiF6nk3Gyvc-Q@mail.gmail.com> <CALCETrUGc5+CS8=sYvtkK967ZR833zu98rzRkEw_DX++1hL-BA@mail.gmail.com> <5320E885.1080402@linux.intel.com> <CALCETrXbgHMPU7in4ThRWyRTw4EN4W9vYOh1RKAiBLFTauxrRQ@mail.gmail.com>
In-Reply-To: <CALCETrXbgHMPU7in4ThRWyRTw4EN4W9vYOh1RKAiBLFTauxrRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 04:43 PM, Andy Lutomirski wrote:
>>
>> I do hear vsyscall=native still being used as a workaround for problems,
>> but yes, just making it call the kernel is fine, of course.
> 
> Next time you hear that, can you let me know?  I haven't heard of any
> issues since 3.4 IIRC.
> 

Will do.

	-hpa


