Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaBNTNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:13:55 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:56431 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaBNTNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:13:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140214101724.GC10590@arm.com>
References: <20140213195230.GA15275@www.outflux.net>
	<20140214101724.GC10590@arm.com>
Date: Fri, 14 Feb 2014 11:13:53 -0800
X-Google-Sender-Auth: fT_8rhP_heYjE22pgF2I5Byo3uc
Message-ID: <CAGXu5jKYq=0Ud-A6bdD2zMe=+r0S7nja8Rg+OxeT+JHzdpwTKg@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: mm: report both sections from PMD
From: Kees Cook <keescook@chromium.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 2:17 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Thu, Feb 13, 2014 at 07:52:30PM +0000, Kees Cook wrote:
>> On 2-level page table systems, the PMD has 2 section entries. Report
>> these, otherwise ARM_PTDUMP will miss reporting permission changes on
>> odd section boundaries.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

On Fri, Feb 14, 2014 at 9:05 AM, Steve Capper <steve.capper@linaro.org> wrote:
> Tested-by: Steve Capper <steve.capper@linaro.org>

Thanks to both of you! If you have a moment can you check this other
patch which has additional fixes for the dump code?

https://lkml.org/lkml/2014/2/12/662

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
