Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaHSWXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 18:23:45 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:56338 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHSWXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 18:23:44 -0400
MIME-Version: 1.0
In-Reply-To: <1408486751.4058.37.camel@snotra.buserror.net>
References: <1408484166-20711-1-git-send-email-bobby.prani@gmail.com> <1408486751.4058.37.camel@snotra.buserror.net>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 19 Aug 2014 18:23:12 -0400
Message-ID: <CAJhHMCAA3rLkszp=Fk9mC81f9+qe8JU_TB6RG3rzdnmpR07jJA@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Make 256k pages depend on PPC32=n
To: Scott Wood <scottwood@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 6:19 PM, Scott Wood <scottwood@freescale.com> wrote:

>>  config PPC_256K_PAGES
>>       bool "256k page size" if 44x
>> -     depends on !STDBINUTILS
>> +     depends on !PPC32 && !STDBINUTILS
>>       help
>>         Make the page size 256k.
>>
>
> How will this ever be selected then?  44x is 32-bit only.

Indeed. I am actually confused about the error which is being thrown
here. The operand (65536) is actually within the range. Any suggestions
on how to fix this?


-- 
Pranith
