Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaBLEad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 23:30:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55830 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbaBLEac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 23:30:32 -0500
Message-ID: <52FAF8AD.1000800@zytor.com>
Date: Tue, 11 Feb 2014 20:29:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Andrey Panin <pazke@donpac.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Dobson <colpatch@us.ibm.com>,
        Natalie Protasevich <protasnb@gmail.com>,
        Garry Forsgren <garry.forsgren@unisys.com>
Subject: Re: [GIT PULL] x86, apic: Remove support for Summit and ES7000
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com> <87txcc57y2.fsf@tassilo.jf.intel.com> <alpine.DEB.2.02.1402061430420.29446@chino.kir.corp.google.com> <52F40F21.8070200@zytor.com> <alpine.DEB.2.02.1402111841590.26393@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402111841590.26393@chino.kir.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 06:53 PM, David Rientjes wrote:
> Hi Ingo, Peter, and Thomas,
> 
>  [ Be aware of bouncing emails on the cc, it includes the last-known email
>    addresses of the authors of these subarchitectures and may bounce. ]
> 
> If you agree, please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rientjes/linux.git x86/apic
> 
>   # HEAD: 7cf6c94591bbf3dbe3bf9573a6551328ad76d885 x86, apic: Remove support for IBM Summit/EXA chipset
> 
> or apply individually.  This branch is based on x86/apic.
> 
> This is the removal of Summit and ES7000 subarchitectures from x86.  I'd 
> like to do the same for NumaQ, but am still researching if we can really 
> do away with it.

Nice.

	-hpa


