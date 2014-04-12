Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbaDLWZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 18:25:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57454 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbaDLWZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 18:25:48 -0400
Message-ID: <5349BD3F.6000402@zytor.com>
Date: Sat, 12 Apr 2014 15:25:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>	<CAMzpN2jn69_E7UEP6OHBbc4r7UuJbsW50WA25YhXuQs5sHFxQQ@mail.gmail.com>	<6f5f98f2-aa96-433f-9ee8-5ba216624957@email.android.com>	<20140412193541.GA30697@pd.tnic>	<21a22ace-fbc3-4f97-a277-9cdf4f2253eb@email.android.com> <CA+55aFy8s7cfaAXJ7WyJ4aMpBnsWGt2mA1=pduQwK+ofkvbzVg@mail.gmail.com>
In-Reply-To: <CA+55aFy8s7cfaAXJ7WyJ4aMpBnsWGt2mA1=pduQwK+ofkvbzVg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2014 02:53 PM, Linus Torvalds wrote:
> On Sat, Apr 12, 2014 at 12:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Run a 32-bit VM.  The 32-bit kernel does this right.
> 
> I really don't think that's the answer.
> 
> If people really run these 16-bit programs, we need to allow it.
> Clearly it used to work.
> 
> Just make the unconditional "don't allow 16-bit segments" be a sysconf entry.
> 

Well, is there more than one user, really... that's my question.

But yes, we can make it configurable, but the default should almost
certainly be off.

	-hpa


