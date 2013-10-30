Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3J3ML7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:11:59 -0400
Received: from intranet.asianux.com ([58.214.24.6]:46932 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3J3ML6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:11:58 -0400
X-Spam-Score: -100.8
Message-ID: <5270F748.5060900@asianux.com>
Date: Wed, 30 Oct 2013 20:10:48 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Francois Bedard <Francois.Bedard@synopsys.com>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Zissulescu <Claudiu.Zissulescu@synopsys.com>,
        joern Rennecke <joern.rennecke@embecosm.com>
Subject: Re: [Suggestion] arc: compiler: bug: about an arc compiler's bug
 which is not in gcc main source code.
References: <523FD9E7.3050303@asianux.com> <523FDBD7.4040602@asianux.com> <C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com> <523FE578.5060801@asianux.com> <52672DAC.1030307@asianux.com> <3B8191AEEF8AD9429F893BDAAB473CA258E064A4@US01WEMBX2.internal.synopsys.com> <52673E9B.6040800@asianux.com> <52706456.5060802@asianux.com>
In-Reply-To: <52706456.5060802@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 09:43 AM, Chen Gang wrote:
> On 10/23/2013 11:12 AM, Chen Gang wrote:
>> On 10/23/2013 10:51 AM, Francois Bedard wrote:
>>> Our sources are on github at https://github.com/foss-for-synopsys-dwc-arc-processors  and you can report problems by opening "Issues" with command lines and log outputs below against relevant toolchain component:
>>>
>>> For GCC:  https://github.com/foss-for-synopsys-dwc-arc-processors/gcc/issues?state=open
>>> For binutils: https://github.com/foss-for-synopsys-dwc-arc-processors/binutils/issues?page=1&state=open 
>>>
>>> Go ahead and officially file these and we'll take a look at them. 
>>
> 
> Hello Francois, I marked them at 2013-10-26 night (China time).
> 
>   for gcc (3 issues, but #28 duplicates with #26): 
> 
>     https://github.com/foss-for-synopsys-dwc-arc-processors/gcc/issues/26
>     https://github.com/foss-for-synopsys-dwc-arc-processors/gcc/issues/27
>     https://github.com/foss-for-synopsys-dwc-arc-processors/gcc/issues/28
> 
>   for binutils (1 issue):
> 
>     https://github.com/foss-for-synopsys-dwc-arc-processors/binutils/issues/21
> 
> 
> Hello Joern, for current shrinking status:
> 
>   for gcc issue #26, (#28 is its duplication):
> 
>     issue command: arc-elf32-gcc -Os -fno-reorder-blocks -c systohc.i
>     source code:   systohc.i contents 41 lines (past it on website).
>     whether GNU:   only for arc, gnu no issue: gnu gcc-4.8/4.9 are OK.
> 
>   for gcc issue #27:
> 
>     issue command: arc-elf32-gcc -Os -c target_core_pr.i
>     status:        just shrinking code.
>                    will/should be finish within 2013-10-31.
>                    welcome any suggestions or completions.
> 

For gnu gcc 4.8/4.9, it is OK (not cause issue). The target_core_pr.i is
still large, I will try to let is smaller and then upload to the website
tomorrow.

Welcome any suggestions or completions (especially for shrinking size,
or only generate related insn tree is enough?).

Thank.

>   for binutils issue #21:
> 
>     it seems simple enough, if still need shrinking, please let me know.
> 
> 
> It seems no response, and I am a newbie about the website, need I do
> something more for them? (e.g. cc to some members, although I don't
> know how to cc).
> 
>> I will/should go ahead, hope I can finish reporting them within this
>> week (2013-10-27)
>>
>> Thanks.
>>
> 
> Thanks.
> 


-- 
Chen Gang
