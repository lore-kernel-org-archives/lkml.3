Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab3J1K4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:56:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57110 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab3J1K4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:56:48 -0400
Message-ID: <526E421A.3090507@zytor.com>
Date: Mon, 28 Oct 2013 03:53:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Andreas Werner <wernerandy@gmx.de>
CC: Borislav Petkov <bp@alien8.de>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
References: <20131027133401.GB24817@pd.tnic> <20131027165159.GD1617@thinkpad.fritz.box> <20131027173131.GC21868@pd.tnic> <20131027175608.GA1340@thinkpad.fritz.box> <20131027190148.GD21868@pd.tnic> <20131028062946.GA1391@thinkpad.fritz.box> <20131028101749.GA4389@gmail.com> <20131028102938.GD4314@pd.tnic> <20131028103132.GA6274@gmail.com> <20131028104505.GB2278@thinkpad.fritz.box> <20131028105101.GC6274@gmail.com>
In-Reply-To: <20131028105101.GC6274@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 03:51 AM, Ingo Molnar wrote:
>>
>> If i mark the region WB and call clflush my system will crash without
>> any message, it just stop working.
> 
> Yeah, I was wondering whether it's valid at all to mark IO memory as 
> cacheable - with the lack of MESI transactions and all that ...
> 
> So it's apparently not valid and we've got to live with WT as the 
> 'best' caching/bursting method for reads.
> 

On a lot of systems I'm not sure if even WT is legitimate.

	-hpa


