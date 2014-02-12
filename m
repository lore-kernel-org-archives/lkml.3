Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaBLMu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 07:50:29 -0500
Received: from one.firstfloor.org ([193.170.194.197]:58886 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaBLMu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 07:50:28 -0500
Date: Wed, 12 Feb 2014 13:50:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave.hansen@intel.com>, Andrey Panin <pazke@donpac.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Dobson <colpatch@us.ibm.com>,
        Natalie Protasevich <protasnb@gmail.com>,
        Garry Forsgren <garry.forsgren@unisys.com>
Subject: Re: [GIT PULL] x86, apic: Remove support for Summit and ES7000
Message-ID: <20140212125026.GU11821@two.firstfloor.org>
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com>
 <87txcc57y2.fsf@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1402061430420.29446@chino.kir.corp.google.com>
 <52F40F21.8070200@zytor.com>
 <alpine.DEB.2.02.1402111841590.26393@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402111841590.26393@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is the removal of Summit and ES7000 subarchitectures from x86.  I'd 
> like to do the same for NumaQ, but am still researching if we can really 
> do away with it.

Nice!

How about VISWS?

Please also check if some arch abstracion innline wrappers are not needed
anymore.

I suspect removing numaq will be most helpful, iirc it was the most intrusive.

-Andi
