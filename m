Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaGTEPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 00:15:09 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:50783 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaGTEPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 00:15:07 -0400
MIME-Version: 1.0
In-Reply-To: <53CB413B.4090409@gmail.com>
References: <CAPDOMVh9knmN1y-LZWvsAKcrKKPQsi0+skNG1D0aQgP+hg3ssQ@mail.gmail.com>
	<53CB413B.4090409@gmail.com>
Date: Sun, 20 Jul 2014 00:15:06 -0400
Message-ID: <CAPDOMVgJHnWc=BedeTxdr1FPR6KxEJXu9urGqi1B3HYTy3xz0w@mail.gmail.com>
Subject: Re: Arm Build Failing
From: Nick Krause <xerofoify@gmail.com>
To: "Roberto J. Dohnert" <rjdohnert@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 12:10 AM, Roberto J. Dohnert
<rjdohnert@gmail.com> wrote:
> It looks like its trying to invoke the native (x86) compiler, but passing it
> options that only make sense to an ARM compiler.
>
> Cheers
>
> Roberto J. Dohnert
> Roberto J. Dohnert
> Lead Developer
> Black Lab Software Inc.
> PO Box 698
> Franklinton NC 27525
> http://www.pc-opensystems.com
> http://www.blacklablinux.org
>
>
> On 07/20/2014 12:03 AM, Nick Krause wrote:
>>
>> arm-linux-gnueabihf-gcc: error: unrecognized command line option ‘-m64’
>> arm-linux-gnueabihf-gcc: error: unrecognized command line option
>> ‘-mno-mmx’
>> arm-linux-gnueabihf-gcc: error: unrecognized command line option
>> ‘-mno-sse’
>> arm-linux-gnueabihf-gcc: error: unrecognized command line option
>> ‘-mno-red-zone’
>> arm-linux-gnueabihf-gcc: error: unrecognized command line option
>> ‘-mcmodel=kernel’
>> This happens every time I try to build new arch code this week. Is there a
>> easy
>> fix for this?
>> Cheers Nick
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
That was a stupid mistake :). I would like to known how to cross
compile only one directory
as I am primarily doing arm fix mes.
Cheers Nick
