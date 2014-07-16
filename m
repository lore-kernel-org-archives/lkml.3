Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaGPVhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:37:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45922 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbaGPVhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:37:38 -0400
Message-ID: <53C6F078.4000201@zytor.com>
Date: Wed, 16 Jul 2014 14:36:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
References: <cover.1405477965.git.luto@amacapital.net> <20140716064110.GV18167@minantech.com> <53C62563.6050106@redhat.com> <53C62B68.50702@redhat.com> <CALCETrVLJ7qH3y04K9Sz1pU3i9+H9Cq_RoDfBeWnsH0VC68qKw@mail.gmail.com> <53C6A236.7040904@zytor.com> <53C6A362.7090709@redhat.com> <53C6A4A3.1040702@zytor.com> <20140716162133.GO4399@minantech.com> <53C6DEA5.7010203@zytor.com> <CALCETrX4MVbkmMejQ6O_-Wt_uKDfR1K=XGnb3_59w-hmzV++iA@mail.gmail.com>
In-Reply-To: <CALCETrX4MVbkmMejQ6O_-Wt_uKDfR1K=XGnb3_59w-hmzV++iA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 02:32 PM, Andy Lutomirski wrote:
> 
> On the theory that I see no legitimate reason to expose this to guest
> user space, I think we shouldn't expose it.  If we wanted to add a
> get_random_bytes syscall, that would be an entirely different story,
> though.
> 
> Should I send v3 as one series or should I split it into host and guest parts?
> 

It doesn't matter... as long as they are separate *patches*.

	-hpa


