Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab3KHPLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:11:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56921 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747Ab3KHPLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:11:04 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131107223046.GK1962@tassilo.jf.intel.com>
References: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org> <527C0195.50008@zytor.com> <20131107213944.GJ1962@tassilo.jf.intel.com> <CAKv+Gu9W-Pu4DGgB-85A3D4Ps9_FLSQgyK3EM7=k7KE1=xsnwg@mail.gmail.com> <20131107223046.GK1962@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH 0/4] wire up CPU features to udev based module loading
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 08 Nov 2013 07:09:36 -0800
To: Andi Kleen <ak@linux.intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: x86@kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, Steve Capper <steve.capper@linaro.org>
Message-ID: <a36043f3-15cc-40a4-9226-70e357ceb4d8@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I assumed he was referring to just dropping those fields of they didn't make sense for the architecture.  That would make sense to do.

Andi Kleen <ak@linux.intel.com> wrote:
>> - the module aliases host tool has no arch specific dependencies at
>> all except having x86cpu as one of the entries: would you mind
>> dropping the x86 prefix there? Or rather add dependencies on $ARCH?
>> (If we drop it there, we basically end up with 'cpu:' everywhere)
>
>Should be fine.
>
>> - in the vendor/family/model case, it may be preferable to drop these
>> fields entirely from certain modules' aliases if they match on 'any'
>> (provided that the module tools permit this) rather than add
>> architecture, variant, revision, etc  fields for all architectures if
>> they can only ever match on one
>
>The module tools require everything matching with the same wild cards.
>
>So I don't know how "any" would work.
>
>-Andi

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
