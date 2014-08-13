Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaHMRpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:45:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56739 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbaHMRpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:45:49 -0400
Message-ID: <53EBA435.3020207@zytor.com>
Date: Wed, 13 Aug 2014 10:45:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
Subject: Re: [PATCH v5 0/5] random,x86,kvm: Rework arch RNG seeds and get
 some from kvm
References: <cover.1406177531.git.luto@amacapital.net> <CALCETrXtLf3ZFtyrbwj29C=t3PcTxRT2AJWZCUHdKC3AYyUVAA@mail.gmail.com> <20140812191723.GI12871@thunk.org> <CALCETrVmviT=upxHfPfmLy2aUOKdCuCbNg9WZQcx6f=8T8vv=g@mail.gmail.com> <53EB1859.6030800@zytor.com> <20140813143209.GD6437@thunk.org> <CALCETrUQ8yRmmN1kbdCy99ae2+-Xp4caOBgrXvaQhCCUi=i0zg@mail.gmail.com>
In-Reply-To: <CALCETrUQ8yRmmN1kbdCy99ae2+-Xp4caOBgrXvaQhCCUi=i0zg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 09:13 AM, Andy Lutomirski wrote:
> 
> Sounds good to me.
> 
> FWIW, I'd like to see a second use added in random.c: I think that we
> should do this, or even all of init_std_data, on resume from suspend
> and especially on resume from hibernate / kexec.
> 

Yes, we should.  We also need to make it possible to do this after
cloning a VM.

	-hpa


