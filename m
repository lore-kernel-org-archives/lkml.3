Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaGHD5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:57:35 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65333 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaGHD5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:57:34 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BB6C2D.60209@roeck-us.net>
Date: Mon, 07 Jul 2014 20:57:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Fwd: Allyesconfig for powerpc still Failing
References: <CAPDOMVi5ptjaKzT+Exd3XtKcy7W7nNZYUD+MEwN8LmhPrQTZBQ@mail.gmail.com>	<53BB6067.1090402@roeck-us.net> <CAPDOMVgeUWGtMC2yssh3zz6y208mHW5WCduDCwr+J09d7LF+CQ@mail.gmail.com>
In-Reply-To: <CAPDOMVgeUWGtMC2yssh3zz6y208mHW5WCduDCwr+J09d7LF+CQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 08:38 PM, Nick Krause wrote:
> On 07/07/2014 07:45 PM, Nick Krause wrote:
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

