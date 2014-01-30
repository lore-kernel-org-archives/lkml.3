Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaA3Fla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 00:41:30 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49651 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaA3Fl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 00:41:27 -0500
Message-ID: <52E9E609.5020202@gmail.com>
Date: Thu, 30 Jan 2014 13:41:29 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Vineet Gupta <vgupta@synopsys.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3] arch: use ASM_NL instead of ';' for assembler new
 line character in the macro
References: <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com> <526F09B8.9030202@asianux.com> <526F11C0.1030809@asianux.com> <526F149A.3000306@asianux.com> <52733FEC.4010807@synopsys.com> <528DD92E.9070408@synopsys.com> <52C6AF2B.8050104@suse.cz> <C2D7FE5348E1B147BCA15975FBA23075175CC4@IN01WEMBXA.internal.synopsys.com> <52CA76D3.2010102@suse.cz> <52CE4496.5030401@synopsys.com> <52D01639.9000205@gmail.com> <52D1F6F1.1070006@gmail.com> <52DA4D09.7030904@gmail.com> <C2D7FE5348E1B147BCA15975FBA23075178198@IN01WEMBXA.internal.synopsys.com> <52E39B07.20309@gmail.com> <52E6D63D.5050808@suse.cz>
In-Reply-To: <52E6D63D.5050808@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 05:57 AM, Michal Marek wrote:
> Dne 25.1.2014 12:07, Chen Gang napsal(a):
>> On 01/21/2014 12:55 PM, Vineet Gupta wrote:
>>> Hi Mike,
>>>
>>> On Saturday 18 January 2014 03:14 PM, Chen Gang wrote:
>>>> Hello Maintainers:
>>>>
>>>> Please help check this patch when you have time.
>>>>
>>>> Thanks.
>>>
>>> Do you know whose tree this is goona go thru. I can take it thru ARC (but maybe
>>> for 3.15, however it would be better it went thru mm or some such).
>>>
>>
>> Hello all:
>>
>> Is this patch OK? if need additional improvement, please let me know,
>> thanks.
> 
> I applied the patch to kbuild.git#kbuild, sorry for the delay.
> 

That's all right (in fact, don't need sorry), most of us are really
busy, so thank you very much for your work on it.

And next, I will/should continue make patches for upstream kernel in my
free time (at least, should provide 1-3 patches per month in this year).

:-)

Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
