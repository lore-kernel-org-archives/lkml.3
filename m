Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbbAIVgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:36:42 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51723 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219AbbAIVgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:36:41 -0500
Message-ID: <54B0496B.5080809@vanguardiasur.com.ar>
Date: Fri, 09 Jan 2015 18:34:35 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Organization: VanguardiaSur
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] UBI: Fastmap: Care about the protection queue
References: <1416835236-25185-1-git-send-email-richard@nod.at> <1416835236-25185-2-git-send-email-richard@nod.at> <54B046BC.8060802@vanguardiasur.com.ar> <54B0489D.1050905@nod.at>
In-Reply-To: <54B0489D.1050905@nod.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/09/2015 06:31 PM, Richard Weinberger wrote:
> Am 09.01.2015 um 22:23 schrieb Ezequiel Garcia:
>> On 11/24/2014 10:20 AM, Richard Weinberger wrote:
>>> Fastmap can miss a PEB if it is in the protection queue
>>> and not jet in the used tree.
>>
>> s/jet/yet
>>
>>> Treat every protected PEB as used.
>>>
>>
>> I'm wondering if we can have a detailed description of the issues this
>> commit fixes (if any?). In other words, what's the result of *not*
>> having the patch?
> 
> Without this patch fastmap can miss one PEB.
> As consequence of this during attach the fastmap self-check
> will detect this inconsistency and will fall back to a full scan.
> If you try to attach using a custom fastmap implementation (found in
> bootloaders) which do often not have sophisticated self-checks you'll
> face a serious data corruption or if you're lucky UBI will crash.
> 
> Now clearer? :-)
> 

Much better!

Thanks a lot,
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
