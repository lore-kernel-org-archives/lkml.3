Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaBLIks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:40:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57917 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbaBLIkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:40:41 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140212070645.GB4373@gmail.com>
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com> <87txcc57y2.fsf@tassilo.jf.intel.com> <alpine.DEB.2.02.1402061430420.29446@chino.kir.corp.google.com> <52F40F21.8070200@zytor.com> <alpine.DEB.2.02.1402111841590.26393@chino.kir.corp.google.com> <52FAF8AD.1000800@zytor.com> <20140212070645.GB4373@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [GIT PULL] x86, apic: Remove support for Summit and ES7000
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 12 Feb 2014 00:39:28 -0800
To: Ingo Molnar <mingo@kernel.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave.hansen@intel.com>, Andrey Panin <pazke@donpac.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Dobson <colpatch@us.ibm.com>,
        Natalie Protasevich <protasnb@gmail.com>,
        Garry Forsgren <garry.forsgren@unisys.com>
Message-ID: <553e717b-8be8-4624-8613-e661dea04208@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running tests on this branch, will push it into tip tomorrow if ok.

On February 11, 2014 11:06:45 PM PST, Ingo Molnar <mingo@kernel.org> wrote:
>
>* H. Peter Anvin <hpa@zytor.com> wrote:
>
>> On 02/11/2014 06:53 PM, David Rientjes wrote:
>> > Hi Ingo, Peter, and Thomas,
>> > 
>> >  [ Be aware of bouncing emails on the cc, it includes the
>last-known email
>> >    addresses of the authors of these subarchitectures and may
>bounce. ]
>> > 
>> > If you agree, please pull from:
>> > 
>> >   git://git.kernel.org/pub/scm/linux/kernel/git/rientjes/linux.git
>x86/apic
>> > 
>> >   # HEAD: 7cf6c94591bbf3dbe3bf9573a6551328ad76d885 x86, apic:
>Remove support for IBM Summit/EXA chipset
>> > 
>> > or apply individually.  This branch is based on x86/apic.
>> > 
>> > This is the removal of Summit and ES7000 subarchitectures from x86.
> I'd 
>> > like to do the same for NumaQ, but am still researching if we can
>really 
>> > do away with it.
>> 
>> Nice.
>
>I'm fine with this too.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
