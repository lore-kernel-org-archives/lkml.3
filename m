Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaLBJn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:43:26 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:65503 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaLBJnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:43:23 -0500
MIME-Version: 1.0
In-Reply-To: <522b42cef4da41d48e81d99bc8e447a8@BL2FFO11FD047.protection.gbl>
References: <2e3f47e730975654f9b6c888a07db6c3f886b892.1417438852.git.michal.simek@xilinx.com>
 <CA+V-a8vw2d8H=Qx99M4oXqUatt5wmePVW82ARdMcWLEVLXbZJw@mail.gmail.com> <522b42cef4da41d48e81d99bc8e447a8@BL2FFO11FD047.protection.gbl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 2 Dec 2014 09:42:51 +0000
Message-ID: <CA+V-a8voyQAmKEO3G26GxDOYWSijfron=OO4RKNdo1OM_pecXA@mail.gmail.com>
Subject: Re: [PATCH v1] lib/genalloc.c: Export devm_gen_pool_create for modules
To: Michal Simek <michal.simek@xilinx.com>
Cc: LKML <linux-kernel@vger.kernel.org>, monstr <monstr@monstr.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laura Abbott <lauraa@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Tue, Dec 2, 2014 at 9:36 AM, Michal Simek <michal.simek@xilinx.com> wrote:
> On 12/02/2014 10:31 AM, Prabhakar Lad wrote:
>> Hi Michal,
>>
>> Thanks for the patch.
>>
>> On Mon, Dec 1, 2014 at 1:00 PM, Michal Simek <michal.simek@xilinx.com> wrote:
>>> Modules can use this function for creating pool.
>>>
>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>> ---
>>>
>>> I am pushing Zynq OCMC driver which is using this function.
>>>
>>> ---
>>>  lib/genalloc.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>> don’t you need to add an entry in include/linux/genalloc.h ?
>
> Not sure what exactly you mean. declaration is there.
> include/linux/genalloc.h:120:extern struct gen_pool *devm_gen_pool_create(struct device *dev,
>
> And all EXPORT_SYMBOL() are out of headers directly below function
> which you want to export.
>
> Can you please clarify what you did mean by that?
>
Oops missed it, since it was a exported function I was expecting a entry
in a header file, but yes the entry  exists already so,

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks,
--Prabhakar Lad
