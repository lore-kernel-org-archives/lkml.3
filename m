Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaDYVR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:17:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46071 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaDYVRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:17:23 -0400
Message-ID: <535AD0A0.4080006@zytor.com>
Date: Fri, 25 Apr 2014 14:16:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, boris.ostrovsky@oracle.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andy Lutomirski <amluto@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com> <535714A1.9080502@linux.intel.com> <20140425210241.GB30532@phenom.dumpdata.com>
In-Reply-To: <20140425210241.GB30532@phenom.dumpdata.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 02:02 PM, Konrad Rzeszutek Wilk wrote:
> 
> Any particular reason you are using __pgd
> 
> _pud
> 
> and _pmd?
> 
> and __pte instead of the 'pmd', 'pud', 'pmd' and 'pte' macros?
> 

Not that I know of other than that the semantics of the various macros
are not described anywhere to the best of my knowledge.

	-hpa


