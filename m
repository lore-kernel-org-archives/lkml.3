Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaGHE5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:57:53 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:52671 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaGHE5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:57:52 -0400
MIME-Version: 1.0
In-Reply-To: <53BB6C2D.60209@roeck-us.net>
References: <CAPDOMVi5ptjaKzT+Exd3XtKcy7W7nNZYUD+MEwN8LmhPrQTZBQ@mail.gmail.com>
	<53BB6067.1090402@roeck-us.net>
	<CAPDOMVgeUWGtMC2yssh3zz6y208mHW5WCduDCwr+J09d7LF+CQ@mail.gmail.com>
	<53BB6C2D.60209@roeck-us.net>
Date: Tue, 8 Jul 2014 00:57:51 -0400
Message-ID: <CAPDOMVj0LPN1+wb-vj4ruruz4bpQb4X5nvRVtNWMpQecVgmd6A@mail.gmail.com>
Subject: Fwd: Fwd: Allyesconfig for powerpc still Failing
From: Nick Krause <xerofoify@gmail.com>
To: linux@roeck-us.net
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck on  Mon, Jul 7, 2014 at 11:57 PM wrote
Subject: Re: Fwd: Allyesconfig for powerpc still Failing
To: Nick Krause <xerofoify@gmail.com>, "linux-kernel@vger.kernel.org"
<linux-kernel@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org"
<linuxppc-dev@lists.ozlabs.org>


On 07/07/2014 08:38 PM, Nick Krause wrote:
>
> On 07/07/2014 07:45 PM, Nick Krause wrote:
>>
>>
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
>
> Guenter Roeck wrote on Mon, Jul 7, 2014 at 11:07 PM
> I submitted a patch to work around this problem a couple of weeks ago [1].
> Unfortunately, with this patch applied, allyesconfig still fails with
> relocation errors, but at least the above message is gone, and
> allmodconfig passes.
>
> Maybe we can convince Ben to accept the patch ...
>
> Thanks,
> Guenter
>
> ---
> [1] https://lkml.org/lkml/2014/6/30/607
>
> Hey Guenter,
> Would you mind sending me the patch that fixes these errors.
> I would like to test it before sending in to Ben.
> Cheers Nick
>

Hi Nick,

Just follow the link above, select 'forward', and follow the directions.
You'll get the patch per e-mail.

Alternative:

wget "http://download.gmane.org/gmane.linux.kernel/1736036/1736037"

The patch will be in a file named '1736037'.

I copied the list for others, in case the 'how to download a patch'
question comes up again.

Guenter

Guenter,
Your patch works for me in building the powerpc allyesconfig.
This is one news, I am going to send this patch to Ben.
Cheers Nick
