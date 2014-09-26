Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaIZLPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:15:39 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56756 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaIZLPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:15:37 -0400
Date: Fri, 26 Sep 2014 13:15:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Mathias Krause <minipli@googlemail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 2/3] x86, ptdump: Simplify page flag evaluation code
Message-ID: <20140926111533.GA9870@gmail.com>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
 <1411313216-2641-3-git-send-email-minipli@googlemail.com>
 <541F2BCD.2040007@linux.intel.com>
 <CA+rthh_UJWqeTJP9aewuC0HRo9wnucy5GScqYH0=0ob=bn4nBw@mail.gmail.com>
 <20140924074555.GA3797@gmail.com>
 <CA+rthh9HRMg0E3gE11F+KSdyMpjYC6d=gZhcu5-1TDqMfAw3Uw@mail.gmail.com>
 <20140926092539.GA9649@gmail.com>
 <20140926101112.GE2062@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926101112.GE2062@nazgul.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Sep 26, 2014 at 11:25:39AM +0200, Ingo Molnar wrote:
>
> > We always welcome cleanups that are a side effect of feature 
> > work. Cleanups for code that is perfectly readable, just for 
> > cleanup's sake, is counterproductive ...
> 
> Greg says there's enough work to be done in the staging drivers 
> if people wanna. :-)

Yeah, and drivers/staging/ is often unreadable code, so doing 
cleanups there is inherently useful.

Thanks,

	Ingo
