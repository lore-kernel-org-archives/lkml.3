Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaIJXfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:35:17 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:2775 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaIJXfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:35:16 -0400
Message-ID: <1410391481.28990.317.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 2/6] x86, mm, pat: Change reserve_memtype() to handle
 WT
From: Toshi Kani <toshi.kani@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yigal Korman <yigal@plexistor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 10 Sep 2014 17:24:41 -0600
In-Reply-To: <5410C9F1.7030603@zytor.com>
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com>
		 <1410367910-6026-3-git-send-email-toshi.kani@hp.com>
		 <CALCETrXRjU3HvHogpm5eKB3Cogr5QHUvE67JOFGbOmygKYEGyA@mail.gmail.com>
		 <1410377428.28990.260.camel@misato.fc.hp.com> <5410B10A.4030207@zytor.com>
		 <1410381050.28990.295.camel@misato.fc.hp.com>
		 <CALCETrUz016rDogLFTVETLh7ybVjgOMOhkL5kF2wJTLUF041xQ@mail.gmail.com>
		 <1410383484.28990.303.camel@misato.fc.hp.com>
		 <CALCETrV4DEr7tQUPCSzJMjBwgJ3-Xgcw8PFt_CCDbMoWRQ4Uug@mail.gmail.com>
		 <5410C4F7.4080704@zytor.com> <1410385673.28990.313.camel@misato.fc.hp.com>
	 <5410C9F1.7030603@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 15:00 -0700, H. Peter Anvin wrote:
> On 09/10/2014 02:47 PM, Toshi Kani wrote:
> >>
> >> Yes.  Don't think of it as PAT vs non-PAT.  Think of it as a specific
> >> set of cache types available on different processors.  The fact that you
> >> may have to frob an MSR to initialize it is almost trivial in comparison.
> > 
> > Right.
> > 
> 
> In that sense the Xen "fixed PAT" fits right in.

Got it. Nicely simplified. :) 

Thanks,
-Toshi


