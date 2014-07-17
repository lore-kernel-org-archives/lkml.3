Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaGQEzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 00:55:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48977 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbaGQEzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 00:55:33 -0400
Message-ID: <53C75733.8060507@zytor.com>
Date: Wed, 16 Jul 2014 21:55:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        Bandan Das <bsd@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 2/5] random,x86: Add arch_get_slow_rng_u64
References: <cover.1405546879.git.luto@amacapital.net> <5778e65d5ca52bebbaa023e177d863e44f098e96.1405546879.git.luto@amacapital.net> <53C6F5A9.80400@zytor.com> <CALCETrVwT1g-S1hLyyB_uAVwffYCnFacTfUhJeD8Bb5j3X0mkg@mail.gmail.com> <CALCETrVCrJEwYokasRoqQTKJWKtzq9XUMNqHoT4-ZjgyZ-mBow@mail.gmail.com> <53C703ED.2010605@zytor.com> <CALCETrVSG_Lp=OSw-U+QK+_VsEhKBS=rBQ3ojTrnO9kAKR+Qag@mail.gmail.com>
In-Reply-To: <CALCETrVSG_Lp=OSw-U+QK+_VsEhKBS=rBQ3ojTrnO9kAKR+Qag@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 05:03 PM, Andy Lutomirski wrote:
>>
>> prandom is exactly the opposite; it is designed for when we need
>> possibly low quality random numbers very quickly.  RDRAND is actually
>> too slow.
> 
> I meant that prandom isn't using rdrand for early seeding.
> 

We should probably fix that.

	-hpa


