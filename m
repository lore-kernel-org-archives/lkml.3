Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaCVA1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 20:27:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42213 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaCVA1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 20:27:13 -0400
Message-ID: <532CD8A9.5080603@zytor.com>
Date: Fri, 21 Mar 2014 17:26:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Wu <peter@lekensteyn.nl>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
References: <4055058.qLAukpngnj@al> <20140321192938.GJ3132@tassilo.jf.intel.com> <970fd799-8d4c-4759-8a96-1291b411f307@email.android.com> <20140321213753.GK3132@tassilo.jf.intel.com> <532CB21B.4040502@zytor.com> <8761n7nryi.fsf@tassilo.jf.intel.com> <532CB54C.8020003@zytor.com> <20140322002244.GP22728@two.firstfloor.org>
In-Reply-To: <20140322002244.GP22728@two.firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 05:22 PM, Andi Kleen wrote:
>> Actually, Ingo, Borislav and I have been discussing making rdmsr_safe()
>> more of the default, especially for things like this where the error
>> handling is obvious (doesn't work?  Disable the PMU.)
> 
> That would be completely wrong. KVM has a full architectural perfmon PMU,
> just no model specific extensions like LBR.
> 

s/PMU/PMU extension in question/

	-hpa


