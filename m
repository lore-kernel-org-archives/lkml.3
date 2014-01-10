Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbaAJPsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:48:14 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61838 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724AbaAJPsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:48:09 -0500
Message-ID: <52D01639.9000205@gmail.com>
Date: Fri, 10 Jan 2014 23:48:09 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] arch: use ASM_NL instead of ';' for assembler new
 line character in the macro
References: <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com> <526F09B8.9030202@asianux.com> <526F11C0.1030809@asianux.com> <526F149A.3000306@asianux.com> <52733FEC.4010807@synopsys.com> <528DD92E.9070408@synopsys.com> <52C6AF2B.8050104@suse.cz> <C2D7FE5348E1B147BCA15975FBA23075175CC4@IN01WEMBXA.internal.synopsys.com> <52CA76D3.2010102@suse.cz> <52CE4496.5030401@synopsys.com>
In-Reply-To: <52CE4496.5030401@synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 02:41 PM, Vineet Gupta wrote:
> Forwarding to Chen's email address:
> 

Oh, thank you for your forwarding, sorry for I really did not notice
about it.

> On Monday 06 January 2014 02:56 PM, Michal Marek wrote:
...
>> Oops :). I wanted to ask if this is the final patch that should be
>> merged, or if there are more known instances of .S code that needs
>> s/;/ASM_NL/. I did not find any suspects outside arch/ by grepping. If
>> this is the final patch, Chen, could you please resubmit it? I do not
>> have the original copy.
>>

OK, thank, I will/should send it again within this week end (before
2014-01-12 night).

And I will/should use my gmail address instead of asianux address as
signed-of-by. (if still need the original one, please let me know,
thanks).


BTW:

I am sorry for replying late, during these days, I changed job, move
house for it, and familiar with related environments (about android
kernel and user mode programs).

But I will/should still need keep 1-3 patches/month for upstream kernel
(and this year, I will/should also need make patches for qemu/kvm/xen,
and toolchain).


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
