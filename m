Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3JaHuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 03:50:16 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:55252 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3JaHuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 03:50:14 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Chen Gang <gang.chen@asianux.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>
CC: "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Claudiu Zissulescu" <Claudiu.Zissulescu@synopsys.com>,
        joern Rennecke <joern.rennecke@embecosm.com>
Subject: Re: [Suggestion] arc: compiler: bug: about an arc compiler's bug
 which is not in gcc main source code.
Thread-Topic: [Suggestion] arc: compiler: bug: about an arc compiler's bug
 which is not in gcc main source code.
Thread-Index: AQHOz5PGbNk3yR8mhEOzI8EAS8PSXw==
Date: Thu, 31 Oct 2013 07:48:09 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075153947@IN01WEMBXA.internal.synopsys.com>
References: <523FD9E7.3050303@asianux.com> <523FDBD7.4040602@asianux.com>
 <C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com>
 <523FE578.5060801@asianux.com> <52672DAC.1030307@asianux.com>
 <3B8191AEEF8AD9429F893BDAAB473CA258E064A4@US01WEMBX2.internal.synopsys.com>
 <52673E9B.6040800@asianux.com> <52706456.5060802@asianux.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

On 10/30/2013 07:14 AM, Chen Gang wrote:
> On 10/23/2013 11:12 AM, Chen Gang wrote:
>> On 10/23/2013 10:51 AM, Francois Bedard wrote:
>>> Our sources are on github at https://github.com/foss-for-synopsys-dwc-arc-processors  and you can report problems by opening "Issues" with command lines and log outputs below against relevant toolchain component:
>>>
>>> For GCC:  https://github.com/foss-for-synopsys-dwc-arc-processors/gcc/issues?state=open
>>> For binutils: https://github.com/foss-for-synopsys-dwc-arc-processors/binutils/issues?page=1&state=open 
>>>
>>> Go ahead and officially file these and we'll take a look at them. 
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
>   for binutils issue #21:
>
>     it seems simple enough, if still need shrinking, please let me know.
>
>
> It seems no response, and I am a newbie about the website, need I do
> something more for them? (e.g. cc to some members, although I don't
> know how to cc).

Many thanks for all your efforts so far.

Most of your patches have already been folded into ARC for 3.13. I will send out
the patches for some of the cross-arch changes in next development cycle as
currently I need to finish up a few things for upcoming merge window.

We are actively working on toolchain issues and hopefully the fixes will make it
into next formal release of tools. Please check back in few weeks.

Thanks,
-Vineet
