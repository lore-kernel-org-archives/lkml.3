Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3KNTGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:06:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42102 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab3KNTGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:06:46 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAKv+Gu8ORgnhPpt-mK2cghiP5CpjSQ=L5JwvMu+wYMaDU7xbtA@mail.gmail.com>
References: <1384165175-16134-1-git-send-email-ard.biesheuvel@linaro.org> <1384165175-16134-5-git-send-email-ard.biesheuvel@linaro.org> <20131114152907.GL20261@arm.com> <CAKv+Gu8ORgnhPpt-mK2cghiP5CpjSQ=L5JwvMu+wYMaDU7xbtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 4/4] arm64: advertise CPU features for modalias matching
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 14 Nov 2013 11:05:54 -0800
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Dave P Martin <Dave.Martin@arm.com>
Message-ID: <7a4ebc9e-3dba-4911-adbe-3097d131793b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/what again?

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>On 14 November 2013 16:29, Catalin Marinas <catalin.marinas@arm.com>
>wrote:
>> On Mon, Nov 11, 2013 at 10:19:35AM +0000, Ard Biesheuvel wrote:
>>> +ssize_t arch_print_cpu_modalias(struct device *dev,
>>> +                             struct device_attribute *attr,
>>> +                             char *buf)
>>> +{
>>> +     unsigned int caps;
>>> +     ssize_t n;
>>> +     int i;
>>> +
>>> +     /*
>>> +      * With 32 features maximum (taking 5 bytes each to print), we
>don't
>>> +      * need to worry about overrunning the PAGE_SIZE sized buffer.
>>> +      */
>>> +     n = sprintf(buf, "cpu:type:arm64:feature:");
>>
>> I would use "aarch64" here instead of arm64 for consistency with the
>> architecture mode, compiler triplet and ELF_PLATFORM definition in
>the
>> kernel.
>
>OK, I will change that.
>
>Regards,
>Ard,

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
