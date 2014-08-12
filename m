Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaHLTWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:22:52 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:58387 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaHLTWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:22:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140812191723.GI12871@thunk.org>
References: <cover.1406177531.git.luto@amacapital.net> <CALCETrXtLf3ZFtyrbwj29C=t3PcTxRT2AJWZCUHdKC3AYyUVAA@mail.gmail.com>
 <20140812191723.GI12871@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 12 Aug 2014 12:22:28 -0700
Message-ID: <CALCETrVmviT=upxHfPfmLy2aUOKdCuCbNg9WZQcx6f=8T8vv=g@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] random,x86,kvm: Rework arch RNG seeds and get some
 from kvm
To: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        kvm list <kvm@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 12:17 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Aug 12, 2014 at 12:11:29PM -0700, Andy Lutomirski wrote:
>>
>> What's the status of this series?  I assume that it's too late for at
>> least patches 2-5 to make it into 3.17.
>
> Which tree were you hoping this patch series to go through?  I was
> assuming it would go through the x86 tree since the bulk of the
> changes in the x86 subsystem (hence my Acked-by).

There's some argument that patch 1 should go through the kvm tree.
There's no real need for patch 1 and 2-5 to end up in the same kernel
release, either.

>
> IIRC, Peter had some concerns, and I don't remember if they were all
> addressed.  Peter?
>

I don't know.  I rewrite one thing he didn't like and undid the other,
but there's plenty of opportunity for this version to be problematic, too.

--Andy
