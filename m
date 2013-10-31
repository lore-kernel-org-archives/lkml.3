Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3JaMDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:03:35 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:51081 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3JaMDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:03:34 -0400
Message-ID: <52724712.6020809@linux.com>
Date: Thu, 31 Oct 2013 13:03:30 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: levex@linux.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>,
        =?UTF-8?B?6Z+p56OK?= <bonben1989@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A simple question of a linux kernel beginner
References: <CAK2Ky6x+wiwa5F6+K+Ee0y_TkbG-oA3tDBWp+2wO8mPqSTyQnA@mail.gmail.com> <CAFLxGvy=pQZBmLuhnY2om-Ypek-B=qTeu_r9P1cgRHcyLxbg-g@mail.gmail.com>
In-Reply-To: <CAFLxGvy=pQZBmLuhnY2om-Ypek-B=qTeu_r9P1cgRHcyLxbg-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-10-31 12:57 keltezéssel, Richard Weinberger írta:
> On Thu, Oct 31, 2013 at 12:31 PM, 韩磊 <bonben1989@gmail.com> wrote:
>> May I can use  the ''double" as a  basic variables?
>>
>> When I define the "double" as a function return type in linux kernel,the error
>> is "error: SSE register return with SSE disabled".
>>
>> How to fix it??
> 
> Don't do it. :)
> In kernel land we don't want FPU stuff because it slows the mode switch down.
> If you *really* need to use the FPU look how the raid6 or crypto code does.

Not only it slows down the switches, but if there is no FPU, then it would
need the so-called floating-point-library. Which would slow down the code,
but the kernel needs to be as fast as it can.

-- 
Regards,
Levente Kurusa
