Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaCaSMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:12:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38914 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaCaSMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:12:35 -0400
Message-ID: <5339B011.7070006@codeaurora.org>
Date: Mon, 31 Mar 2014 11:12:33 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kees Cook <keescook@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Russell King <linux@arm.linux.org.uk>, Rob Herring <robherring2@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] ARM: mm: fix reporting of read-only PMD bits
References: <20140323042050.GA15181@www.outflux.net> <CAGXu5j+GokV1MKv4Otb0AGt4Xvm8WXMLaOvGUUX+BJpo7Myg9g@mail.gmail.com>
In-Reply-To: <CAGXu5j+GokV1MKv4Otb0AGt4Xvm8WXMLaOvGUUX+BJpo7Myg9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/2014 11:45 AM, Kees Cook wrote:
> On Sat, Mar 22, 2014 at 9:20 PM, Kees Cook <keescook@chromium.org> wrote:
>> On non-LPAE ARMv6+, read-only PMD bits are defined with the combination
>> "PMD_SECT_APX | PMD_SECT_AP_WRITE". Adjusted the bit masks to correctly
>> report this.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> v4:
>>  - clean up defines for CPU versions; Rob Herring.
>> v3:
>>  - check for pre-v6 CPUs on the page table report.
>> v2:
>>  - reorder bits, suggested by Olof.
> 
> Can anyone give this a test or ack? I've done build tests for all CPU
> combinations, and runtime tests on v6 and LPAE.
> 
> Thanks!
> 
> -Kees
> 

You are welcome to add

Tested-by: Laura Abbott <lauraa@codeaurora.org>

Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
