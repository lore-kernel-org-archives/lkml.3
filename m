Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaCVAfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 20:35:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42285 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbaCVAfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 20:35:15 -0400
Message-ID: <532CDA92.2080409@zytor.com>
Date: Fri, 21 Mar 2014 17:34:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Wu <peter@lekensteyn.nl>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
References: <4055058.qLAukpngnj@al> <20140321192938.GJ3132@tassilo.jf.intel.com> <970fd799-8d4c-4759-8a96-1291b411f307@email.android.com> <20140321213753.GK3132@tassilo.jf.intel.com> <532CB21B.4040502@zytor.com> <8761n7nryi.fsf@tassilo.jf.intel.com> <532CB54C.8020003@zytor.com> <20140322002244.GP22728@two.firstfloor.org> <532CD8A9.5080603@zytor.com> <20140322003056.GQ22728@two.firstfloor.org>
In-Reply-To: <20140322003056.GQ22728@two.firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 05:30 PM, Andi Kleen wrote:
> 
> %  grep -r 'rdmsr' arch/x86/*  | grep -v safe | wc -l
> 285
> 
> I assume it'll keep you all busy for a while.
> 
> [compared to a likely one liner in KVM]
> 

It's not just KVM, though.

	-hpa


