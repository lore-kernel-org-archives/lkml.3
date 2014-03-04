Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaCDHsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:48:41 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:44014 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457AbaCDHsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:48:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140303140811.GA18828@console-pimps.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
	<1391619853-10601-7-git-send-email-leif.lindholm@linaro.org>
	<20140213112606.GF20717@console-pimps.org>
	<CAFECyb_wUphr4XOyW9tC-Rw5Py3m39e6GQorCtFGtSXTUTBnFQ@mail.gmail.com>
	<20140303140811.GA18828@console-pimps.org>
Date: Mon, 3 Mar 2014 23:48:39 -0800
Message-ID: <CAFECyb9eXYCFTQ7G35EEsx0P2vRwm7qNtwT46ZteTGbycbcEBg@mail.gmail.com>
Subject: Re: [PATCH 06/22] Add helper functions used by arm/arm64
From: Roy Franz <roy.franz@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 6:08 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Fri, 14 Feb, at 11:02:49AM, Roy Franz wrote:
>>
>> The get_dram_base() function is only used by arm/arm64, but
>> there is nothing architecture specific about it, which is why I put it
>> here to begin with.  I don't feel strongly about this either way.
>
> Sorry Roy, I just realised that you probably wanted a response from me
> about this last point.
>
> OK, leaving get_dram_base() in efi-stub-helper.c is fine.
>
> FYI, "NUL" isn't a typo,
>
>> -     options_size++;  /* NUL termination */
> [...]
>> +     options_size++;  /* NULL termination */
>
> http://en.wikipedia.org/wiki/Null_character
>
> --
> Matt Fleming, Intel Open Source Technology Center

Thanks - I'll take care of this in the next revision.

Roy
