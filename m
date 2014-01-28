Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaA1RYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:24:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:32869 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298AbaA1RYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:24:01 -0500
Message-ID: <52E7E79D.30709@ti.com>
Date: Tue, 28 Jan 2014 12:23:41 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Yinghai Lu <yinghai@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org> <1390590670-25901-4-git-send-email-yinghai@kernel.org> <CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com> <CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com> <CAE9FiQU_vZo40cje_XJXSxuKW-JL6H-8rAazwOw1O-ewcV+C5g@mail.gmail.com> <20140128171823.GN15937@n2100.arm.linux.org.uk>
In-Reply-To: <20140128171823.GN15937@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 January 2014 12:18 PM, Russell King - ARM Linux wrote:
> On Tue, Jan 28, 2014 at 09:12:27AM -0800, Yinghai Lu wrote:
>> On Tue, Jan 28, 2014 at 7:30 AM, Kevin Hilman <khilman@linaro.org> wrote:
>>> Like Olof, I noticed multiple boot failures on various ARM boards.
>>> I've confirmed that reverting the arch/arm part of this patch makes
>>> them all happily booting again.
>>
>> please try attached patch.
> 
> Maybe I'm missing something, but there is no ARCH_LOW_ADDRESS_LIMIT
> defined in the ARM header files, so I don't see how adding that
> additional include changes anything.
> 
Our emails crossed... You are right. It won't help.

Regards,
Santosh
