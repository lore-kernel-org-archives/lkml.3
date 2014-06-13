Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaFMBJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 21:09:25 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:57024 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaFMBJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 21:09:24 -0400
MIME-Version: 1.0
In-Reply-To: <539A0BB4.1060204@zytor.com>
References: <cover.1402598632.git.luto@amacapital.net> <ad9f313026949247ed2067631b4e5c27c1935064.1402598632.git.luto@amacapital.net>
 <539A0BB4.1060204@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Jun 2014 18:09:03 -0700
Message-ID: <CALCETrW=mtGOwYLaFv5UmeWo2seCEX9GjM7KryW-rQ0GiN7rBA@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86,vdso: Hack to keep 64-bit Go programs working
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kui Zhang <kuizhang@gmail.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 1:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/12/2014 11:47 AM, Andy Lutomirski wrote:
>>
>> This is currently broken for big-endian build hosts.  The hack
>> should also be disabled for x32, but I'm not sure what the right way
>> to do that is.
>>
>
> Well, if it isn't exported into the x32 vdso it isn't an issue, right?

It was, and it broke the build.  v3 fixes it, at the cost of yet more
makefile churn.

>
>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
