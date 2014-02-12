Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaBLPU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:20:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33205 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaBLPU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:20:27 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140212125026.GU11821@two.firstfloor.org>
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com> <87txcc57y2.fsf@tassilo.jf.intel.com> <alpine.DEB.2.02.1402061430420.29446@chino.kir.corp.google.com> <52F40F21.8070200@zytor.com> <alpine.DEB.2.02.1402111841590.26393@chino.kir.corp.google.com> <20140212125026.GU11821@two.firstfloor.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [GIT PULL] x86, apic: Remove support for Summit and ES7000
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 12 Feb 2014 07:17:58 -0800
To: Andi Kleen <andi@firstfloor.org>, David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave.hansen@intel.com>, Andrey Panin <pazke@donpac.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Dobson <colpatch@us.ibm.com>,
        Natalie Protasevich <protasnb@gmail.com>,
        Garry Forsgren <garry.forsgren@unisys.com>
Message-ID: <cc9f30a7-6eba-422a-bc2e-0e38877e1938@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I would love to get visws and numaq killed off, too.

On February 12, 2014 4:50:26 AM PST, Andi Kleen <andi@firstfloor.org> wrote:
>> This is the removal of Summit and ES7000 subarchitectures from x86. 
>I'd 
>> like to do the same for NumaQ, but am still researching if we can
>really 
>> do away with it.
>
>Nice!
>
>How about VISWS?
>
>Please also check if some arch abstracion innline wrappers are not
>needed
>anymore.
>
>I suspect removing numaq will be most helpful, iirc it was the most
>intrusive.
>
>-Andi

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
