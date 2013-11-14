Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3KNQOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:14:51 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41119 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab3KNQOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:14:24 -0500
MIME-Version: 1.0
In-Reply-To: <20131114152907.GL20261@arm.com>
References: <1384165175-16134-1-git-send-email-ard.biesheuvel@linaro.org>
	<1384165175-16134-5-git-send-email-ard.biesheuvel@linaro.org>
	<20131114152907.GL20261@arm.com>
Date: Thu, 14 Nov 2013 17:14:22 +0100
Message-ID: <CAKv+Gu8ORgnhPpt-mK2cghiP5CpjSQ=L5JwvMu+wYMaDU7xbtA@mail.gmail.com>
Subject: Re: [PATCH 4/4] arm64: advertise CPU features for modalias matching
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Dave P Martin <Dave.Martin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 November 2013 16:29, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Mon, Nov 11, 2013 at 10:19:35AM +0000, Ard Biesheuvel wrote:
>> +ssize_t arch_print_cpu_modalias(struct device *dev,
>> +                             struct device_attribute *attr,
>> +                             char *buf)
>> +{
>> +     unsigned int caps;
>> +     ssize_t n;
>> +     int i;
>> +
>> +     /*
>> +      * With 32 features maximum (taking 5 bytes each to print), we don't
>> +      * need to worry about overrunning the PAGE_SIZE sized buffer.
>> +      */
>> +     n = sprintf(buf, "cpu:type:arm64:feature:");
>
> I would use "aarch64" here instead of arm64 for consistency with the
> architecture mode, compiler triplet and ELF_PLATFORM definition in the
> kernel.

OK, I will change that.

Regards,
Ard,
