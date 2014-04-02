Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbaDBI3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:29:33 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:49486 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758199AbaDBI32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:29:28 -0400
Message-ID: <1396427366.18431.23.camel@x220>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
From: Paul Bolle <pebolle@tiscali.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, gleb@redhat.com,
        hpa@zytor.com, hubicka@ucw.cz, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pbonzini@redhat.com, perex@perex.cz,
        peterz@infradead.org, rostedt@goodmis.org, rusty@rustcorp.com.au,
        tglx@linutronix.de
Date: Wed, 02 Apr 2014 10:29:26 +0200
In-Reply-To: <20140401231741.GM32556@tassilo.jf.intel.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
	 <1396385391.23763.30.camel@x220>
	 <20140401231741.GM32556@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2014 08:29:26.0959 (UTC) FILETIME=[A8DDCBF0:01CF4E4D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 16:17 -0700, Andi Kleen wrote:
> On Tue, Apr 01, 2014 at 10:49:51PM +0200, Paul Bolle wrote:
> > I can't find a Kconfig symbol LTO nor a preprocessor define for
> > CONFIG_LTO. (I only checked master of Linus's tree and linux-next.)
> 
> The patch for LTO is not merged yet, this is all preparation.
> 
> > 
> > Why is this check for CONFIG_LTO needed?
> 
> The comment just below describes the problem.
> 
> Or is your question what LTO is? Link Time Optimization

I asked the wrong question, as I wanted to ask whether a Kconfig symbol
LTO is perhaps pending somewhere. You basically answered that question
already.

Thanks,


Paul Bolle

