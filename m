Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaIJWAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 18:00:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58471 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbaIJWAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 18:00:52 -0400
Message-ID: <5410C9F1.7030603@zytor.com>
Date: Wed, 10 Sep 2014 15:00:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: Andy Lutomirski <luto@amacapital.net>,
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
Subject: Re: [PATCH v2 2/6] x86, mm, pat: Change reserve_memtype() to handle
 WT
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com>	 <1410367910-6026-3-git-send-email-toshi.kani@hp.com>	 <CALCETrXRjU3HvHogpm5eKB3Cogr5QHUvE67JOFGbOmygKYEGyA@mail.gmail.com>	 <1410377428.28990.260.camel@misato.fc.hp.com> <5410B10A.4030207@zytor.com>	 <1410381050.28990.295.camel@misato.fc.hp.com>	 <CALCETrUz016rDogLFTVETLh7ybVjgOMOhkL5kF2wJTLUF041xQ@mail.gmail.com>	 <1410383484.28990.303.camel@misato.fc.hp.com>	 <CALCETrV4DEr7tQUPCSzJMjBwgJ3-Xgcw8PFt_CCDbMoWRQ4Uug@mail.gmail.com>	 <5410C4F7.4080704@zytor.com> <1410385673.28990.313.camel@misato.fc.hp.com>
In-Reply-To: <1410385673.28990.313.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 02:47 PM, Toshi Kani wrote:
>>
>> Yes.  Don't think of it as PAT vs non-PAT.  Think of it as a specific
>> set of cache types available on different processors.  The fact that you
>> may have to frob an MSR to initialize it is almost trivial in comparison.
> 
> Right.
> 

In that sense the Xen "fixed PAT" fits right in.

	-hpa


