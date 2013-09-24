Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3IXMkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:40:05 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:55645 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3IXMkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:40:02 -0400
X-AuditID: cbfec37b-b7fa96d00000716e-12-52418820928f
Message-id: <52418815.20701@samsung.com>
Date: Tue, 24 Sep 2013 06:39:49 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Joerg Roedel <joro@8bytes.org>
Cc: alex.williamson@redhat.com, Varun.Sethi@freescale.com, udknight@gmail.com,
        aik@ozlabs.ru, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 1/2] iommu: Add iommu_fault class event to iommu trace
References: <cover.1376672275.git.shuah.kh@samsung.com>
 <7a14c27d8341e53f2aed7b80e08a4480d89eac5e.1376672275.git.shuah.kh@samsung.com>
 <20130924104855.GB4532@8bytes.org>
In-reply-to: <20130924104855.GB4532@8bytes.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+wr65Ch2OQwbkmZYve40UW3/73sFnM
	fN3NZLFgv7VF5+wN7BaXd81hs7h0YAGTxb6OB0wWX386WGyf8p/JYuatNSwO3B5PDs5j8vh3
	uJ/JY+esu+weLftusXtMvrGc0ePG3WY2j/f7rrJ5fN4kF8ARxWWTkpqTWZZapG+XwJVxfo5I
	wXvWiuaprUwNjBdZuhg5OSQETCTWvNrIDmGLSVy4t56ti5GLQ0hgGaPEuqnbwBJCAr1MEvs+
	1kAkNjFKbFl4iQ0kwSugIXH9zCNWEJtFQFWid/90RhCbTUBd4vPrHVDNchJNS1Yzg9iiAhES
	K5c8YIXoFZT4Mfke2BUiAkoS1z+3gsWZBaYySXzY6QliCwt4SZxu7Ie6aC2jRMPMK2ANnAL6
	Ejf3zIFqsJZYOWkbI4QtL7F5zVtmiMXKEn8un2LqYuQAek1RYvtqqwmMIrOQrJ6FpHsWku4F
	jMyrGMVKi5MLipPSUyuM9IoTc4tL89L1kvNzNzFC4rB6B+PdrzaHGAU4GJV4eCvjHIKEWBPL
	iitzDzFKcDArifBq1joGCfGmJFZWpRblxxeV5qQWH2Jk4uCUamBku5jbqaZtmeUx4dMeb1HV
	v0enfhFSPbhjdf9efeulMZ+b9Gs27Q8UX7/LR2M9u6HW3sJVX3aZJFp98+bs1WySr7fXtrDi
	qFL4PDX27K+iG04/92y0nLhoI7fyy+mml7zKLQqcTzxwfGKttuC/fNPE4O2V8y5e+bLyXPjO
	yYH/Y4z59sbzH1FRYinOSDTUYi4qTgQARPuh46ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 04:48 AM, Joerg Roedel wrote:
> On Fri, Aug 16, 2013 at 11:20:16AM -0600, Shuah Khan wrote:
>> +DEFINE_EVENT(iommu_fault, report_fault,
>> +
>> +	TP_PROTO(struct device *dev, unsigned long iova, int flags),
>> +
>> +	TP_ARGS(dev, iova, flags)
>> +);
>
> I am not entirely happy with the naming. It is better to name the class
> iommu_error and the page-fault event io_page_fault. This makes it more
> clear what kind of fault it is.
>
>
> 	Joerg
>
>

Joerg,

Yes, iommu_error and io_page_fault sounds better. I will rename and send 
the updated patch.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
