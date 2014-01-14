Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaANQrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:47:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52759 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbaANQkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:40:22 -0500
Message-ID: <52D56856.9050201@zytor.com>
Date: Tue, 14 Jan 2014 08:39:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, Aravind.Gopalakrishnan@amd.com,
        tglx@linutronix.de, bp@suse.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/microcode] x86, microcode: Move to a proper location
References: <tip-bad5fa631fca5466401cd4a48e30cc1f1cb6101e@git.kernel.org> <52D56174.9010608@zytor.com> <20140114162203.GB31037@gmail.com> <20140114163617.GA29871@pd.tnic>
In-Reply-To: <20140114163617.GA29871@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 08:36 AM, Borislav Petkov wrote:
> On Tue, Jan 14, 2014 at 05:22:03PM +0100, Ingo Molnar wrote:
>> Absolutely. I think moving arch/x86/kernel/cpu/ to arch/x86/cpu/
>> would be a first good step. It's all kernel code, there's other
>> subdirectories there that are kernel code ('pci/', 'platform/', etc.),
>> so there's little point in continuing the historic accident of a
>> 'kernel/' subdirectory.
>>
>> Once that is done we can move certain things outside as well - for
>> example arch/x86/cpu/perf/ could probably move to arch/x86/events/,
>> because that code is not about CPU events anymore either.
> 
> All fine and dandy with me, but I'd prefer to do this after the merge
> window, i.e. for 3.15. Rushing it now would just cause unnecessary
> trouble IMO.
> 

Oh, absolutely.

	-hpa

