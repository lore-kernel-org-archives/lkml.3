Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaAFJ0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:26:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbaAFJ0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:26:52 -0500
Message-ID: <52CA76D3.2010102@suse.cz>
Date: Mon, 06 Jan 2014 10:26:43 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Chen Gang <gang.chen@asianux.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] arch: use ASM_NL instead of ';' for assembler new
 line character in the macro
References: <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com> <526F09B8.9030202@asianux.com> <526F11C0.1030809@asianux.com> <526F149A.3000306@asianux.com> <52733FEC.4010807@synopsys.com> <528DD92E.9070408@synopsys.com> <52C6AF2B.8050104@suse.cz> <C2D7FE5348E1B147BCA15975FBA23075175CC4@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA23075175CC4@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-06 06:36, Vineet Gupta wrote:
> Hi Michal,
> 
> On Friday 03 January 2014 06:08 PM, Michal Marek wrote:
>> On 2013-11-21 10:58, Vineet Gupta wrote:
>>> On 11/01/2013 11:15 AM, Vineet Gupta wrote:
>>>> +CC Sam, Tim, Joe, Michal, David
>>>>
>>>> Guys can you please take a look at this patch and suggest the best way to merge.
>>>>
>>>> The root cause is some gas ports (including ARC) use ';' for comment (vs. newline)
>>>> More background at https://lkml.org/lkml/2013/10/24/365
>>> Ping ! Any objections to this. Given that this is exception case, it is simpler
>>> than defining a Kconfig control.
>>>
>>> -Vineet
>>>>
>>>> On 10/29/2013 07:21 AM, Chen Gang wrote:
>>>>> For some assemblers, they use another character as newline in a macro
>>>>> (e.g. arc uses '`'), so for generic assembly code, need use ASM_NL (a
>>>>> macro) instead of ';' for it.
>>>>>
>>>>> Also need notice about code styles ('\t' for each line).
>>>>>
>>>>>
>>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>

> 
> Did you hit reply by mistake - as I can't seem to find any comments...

Oops :). I wanted to ask if this is the final patch that should be
merged, or if there are more known instances of .S code that needs
s/;/ASM_NL/. I did not find any suspects outside arch/ by grepping. If
this is the final patch, Chen, could you please resubmit it? I do not
have the original copy.

Michal

