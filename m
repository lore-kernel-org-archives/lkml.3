Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab3F3Cuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 22:50:39 -0400
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:33990 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729Ab3F3Cuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 22:50:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAHSZz1HYNY97/2dsb2JhbAANTIcLvAyBFYMXAQEBBCMVQRALGAICBSECAg8CRgYNAQUCAQGxH3OQSYEmjjgHglGBFgOhZopK
X-IronPort-AV: E=Sophos;i="4.87,967,1363104000"; 
   d="scan'208";a="109384846"
X-WN-REMOTEIP: 216.53.143.123
X-WN-ENVELOPESENDER: gerg@uclinux.org
X-WN-MID: 109384846
X-WN-SMTPAUTHID: gregungerer@westnet.com.au
Message-ID: <51CF9CEB.20800@uclinux.org>
Date: Sun, 30 Jun 2013 12:50:19 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: uClinux development list <uclinux-dev@uclinux.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68knommu: Mark config_BSP() __init
References: <1372189212-12136-1-git-send-email-geert@linux-m68k.org> <51CB745B.4060604@uclinux.org> <CAMuHMdV2XakPGZP5gYygBPgg+DeSRj7qP6hF7T6nN-OQKTodtA@mail.gmail.com>
In-Reply-To: <CAMuHMdV2XakPGZP5gYygBPgg+DeSRj7qP6hF7T6nN-OQKTodtA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 27/06/13 16:49, Geert Uytterhoeven wrote:
> On Thu, Jun 27, 2013 at 1:08 AM, Greg Ungerer <gerg@uclinux.org> wrote:
>> On 26/06/13 05:40, Geert Uytterhoeven wrote:
>>>
>>> Some instances of config_BSP() lack an __init annotation.
>>>
>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>
>>
>> Acked-by: Greg Ungerer <gerg@uclinux.org>
>>
>> Looks good. Are you going to push it via your tree, or do you want
>> me too?
>
> As it's m68nommu, perhaps through your tree? Unless you don't have time to
> handle it.

I can take care of it. Though I may be a little slower than usual,
I am traveling at the moment.

Regards
Greg



