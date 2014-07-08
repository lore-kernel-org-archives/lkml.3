Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaGHDJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:09:31 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:42457 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaGHDJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:09:30 -0400
MIME-Version: 1.0
In-Reply-To: <1404788634.16156.38.camel@pasglop>
References: <CAPDOMVi5ptjaKzT+Exd3XtKcy7W7nNZYUD+MEwN8LmhPrQTZBQ@mail.gmail.com>
	<1404788634.16156.38.camel@pasglop>
Date: Mon, 7 Jul 2014 23:09:29 -0400
Message-ID: <CAPDOMVi8kcCZf1gSvBLWq4+X3ZnrZXcwPstzafM4K_Re4eiKRQ@mail.gmail.com>
Subject: Re: Allyesconfig for powerpc still Failing
From: Nick Krause <xerofoify@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: paulus@samba.org, mahesh <mahesh@linux.vnet.ibm.com>,
        anton <anton@samba.org>, agraf <agraf@suse.de>,
        michael <michael@ellerman.id.au>, svaidy <svaidy@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just hoped this log may help you in your issues with the train wreck.
If you need any help with the issues here please let me know.
Cheers Nick :)

On Mon, Jul 7, 2014 at 11:03 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2014-07-07 at 22:45 -0400, Nick Krause wrote:
>> Today I tested the allyesconfig for powerpc and it seems to be still
>> failing according to my tests.
>> Below are the error messages I get before the jobs finish and exit
>> failing the build.
>> Cheers Nick
>> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
>> arch/powerpc/kernel/exceptions-64s.S:1331: Error: attempt to move .org backwards
>> make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1
>> make: *** [arch/powerpc/kernel] Error 2
>> make: *** Waiting for unfinished jobs....
>
> Yes, it's a trainwreck and I don't know how to fix it yet ... I tried
> various more or less invasive approaches and none of them worked
> properly so far. I need to spend more time on this.
>
> Cheers,
> Ben.
>
>
