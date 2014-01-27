Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaA0V5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:57:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbaA0V5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:57:22 -0500
Message-ID: <52E6D63D.5050808@suse.cz>
Date: Mon, 27 Jan 2014 22:57:17 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, Vineet Gupta <vgupta@synopsys.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3] arch: use ASM_NL instead of ';' for assembler new
 line character in the macro
References: <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com> <526F09B8.9030202@asianux.com> <526F11C0.1030809@asianux.com> <526F149A.3000306@asianux.com> <52733FEC.4010807@synopsys.com> <528DD92E.9070408@synopsys.com> <52C6AF2B.8050104@suse.cz> <C2D7FE5348E1B147BCA15975FBA23075175CC4@IN01WEMBXA.internal.synopsys.com> <52CA76D3.2010102@suse.cz> <52CE4496.5030401@synopsys.com> <52D01639.9000205@gmail.com> <52D1F6F1.1070006@gmail.com> <52DA4D09.7030904@gmail.com> <C2D7FE5348E1B147BCA15975FBA23075178198@IN01WEMBXA.internal.synopsys.com> <52E39B07.20309@gmail.com>
In-Reply-To: <52E39B07.20309@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 25.1.2014 12:07, Chen Gang napsal(a):
> On 01/21/2014 12:55 PM, Vineet Gupta wrote:
>> Hi Mike,
>>
>> On Saturday 18 January 2014 03:14 PM, Chen Gang wrote:
>>> Hello Maintainers:
>>>
>>> Please help check this patch when you have time.
>>>
>>> Thanks.
>>
>> Do you know whose tree this is goona go thru. I can take it thru ARC (but maybe
>> for 3.15, however it would be better it went thru mm or some such).
>>
> 
> Hello all:
> 
> Is this patch OK? if need additional improvement, please let me know,
> thanks.

I applied the patch to kbuild.git#kbuild, sorry for the delay.

Michal

