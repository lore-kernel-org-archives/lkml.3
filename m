Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3ETKaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:30:10 -0400
Received: from avasout07.plus.net ([84.93.230.235]:43353 "EHLO
	avasout07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab3ETKaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:30:08 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2013 06:30:08 EDT
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.1 cv=NbzfiQz4 c=1 sm=1 tr=0
 a=C5+YawzV8SR07mwocaP9vA==:117 a=oVzeRECIuT3d/3eGsnw7Tg==:17 a=0Bzu9jTXAAAA:8
 a=4y5PL32Bs38A:10 a=dYCPD3cKDi0A:10 a=C4HKs7zIHroA:10 a=ihvODaAuJD4A:10
 a=IkcTkHD0fZMA:10 a=EBOSESyhAAAA:8 a=b8LLVqKzTTAA:10 a=VwQbUJbxAAAA:8
 a=eoKyk2uZetrn-HmSi8wA:9 a=QEXdDO2ut3YA:10
X-AUTH: mauve:2500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 20 May 2013 11:24:02 +0100
From: Ian Stirling <gplvio@mauve.plus.com>
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: <legal@lists.gpl-violations.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Would like to form a pool of Linux copyright holders for faster
 GPL enforcement against Anthrax Kernels
In-Reply-To: <CAPweEDztcCOgKQmMSK3R6TMJoOo5m4b5KFg1nVySexqdVZu_DQ@mail.gmail.com>
References: <51972CAF.3060802@gmail.com>
 <CAPweEDxgT+ZygfPZDd8YePe7RurTU7o_UtiBqjUvCMimChpTug@mail.gmail.com>
 <ce644e6e12d68aaabed7403b5f21c124@imap.plus.net>
 <CAPweEDztcCOgKQmMSK3R6TMJoOo5m4b5KFg1nVySexqdVZu_DQ@mail.gmail.com>
Message-ID: <18adac813097459e346581e2d81389be@imap.plus.net>
User-Agent: Roundcube Webmail/0.7.4
X-Originating-IP: [81.174.132.210]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.05.2013 11:57, luke.leighton wrote:
> On Sun, May 19, 2013 at 10:12 AM, Ian Stirling 
> <gplvio@mauve.plus.com> wrote:
>> On 18.05.2013 19:27, luke.leighton wrote:
>>
>>> question: what is the procedure for having that licensing 
>>> explicitly
>>> added to the linux kernel sources?
>>
>>
>> Fork the kernel, and put it up on a repo somewhere that says you're 
>> trying
>> to get it all as
>> GPL3.
<snip>
>
> i wish to know the procedure by which my formally and publicly
> announced release of all linux kernel contributions under the dual
> licenses of GPLv2 and GPLv3+ may be entered - formally - upstream and
> into the linux kernel sources being maintained on git.kernel.org

Umm - that was my point - though I did not make it explicitly.

Either there is a policy change, and it is decided to allow such
dual-licenced code in the repo, or your code does not get checked in,
as it does not have a compatible licence.

If Linus takes the view that he does not wish to allow this - and the
project is not forked - you actually have to do the above.

Sure - you have the right to licence code you write any way you choose.
Linus (and the people involved in maintaining the kernel) have the 
right
to not accept your code under that licence.

