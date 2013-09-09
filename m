Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3IIWkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 18:40:23 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:46549 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3IIWkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 18:40:22 -0400
Message-ID: <522E4E53.8060308@gmail.com>
Date: Mon, 09 Sep 2013 15:40:19 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Pinski <pinskia@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Andrew Pinski <apinski@cavium.com>
Subject: Re: [PATCH 2/5] ARM64: Move some signal code to a seperate file to
 be reused by ILP32.
References: <1378762380-13152-1-git-send-email-apinski@cavium.com> <1378762380-13152-2-git-send-email-apinski@cavium.com> <CA+=Sn1mj1c_k=-++K1jqU1DnYe0sUspbsuP0MMyWx+J-+JZfcw@mail.gmail.com>
In-Reply-To: <CA+=Sn1mj1c_k=-++K1jqU1DnYe0sUspbsuP0MMyWx+J-+JZfcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 02:38 PM, Andrew Pinski wrote:
> On Mon, Sep 9, 2013 at 2:32 PM, Andrew Pinski <pinskia@gmail.com> wrote:
>> Since the ILP32 ABI uses similar signal code as the LP64 ABI, it makes sense to reuse rather
>> than copy the same code.
>
> I just noticed that signal_template.c was not part of this patch but
> it is included with patch number 5.
>

At a minimum, the patch set should be respun so that it builds, runs and 
has no unusable Kconfig options at all intermediate points in the set.

You could also consider splitting out cosmetic changes unrelated to the 
meat of a change to a separate patches.


David Daney
