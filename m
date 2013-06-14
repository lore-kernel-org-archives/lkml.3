Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3FNIfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:35:54 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:46889 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3FNIfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:35:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130614082220.GC22589@linux-mips.org>
References: <1371165583-21907-1-git-send-email-grant.likely@linaro.org> <20130614082220.GC22589@linux-mips.org>
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 14 Jun 2013 09:35:30 +0100
X-Google-Sender-Auth: mDY_rcVxrCnNYutWmuF4b_-VGbo
Message-ID: <CACxGe6snY7zjhx=UfO3Z_zUp1m25H69Fev7uvswoTbE1hRP7CA@mail.gmail.com>
Subject: Re: [PATCH] irqdomain: Remove temporary MIPS workaround code
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 9:22 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Fri, Jun 14, 2013 at 12:19:43AM +0100, Grant Likely wrote:
>
>> The MIPS interrupt controllers are all registering their own irq_domains
>> now. Drop the MIPS specific code because it is no longer needed.
>>
>> Signed-off-by: Grant Likely <grant.likely@linaro.org>
>> Cc: Ralf Baechle <ralf@linux-mips.org>
>> Cc: linux-mips@linux-mips.org
>> ---
>>
>> Ralf, this should be okay to pull out now. I'll be submitting it for
>> v3.11 unless someone yells. Even if so, all the irqdomain infrastructure
>> is in place to make it trivial to add an irqdomain where missing.
>
> I would like to merge this through the MIPS tree so it'll receive
> maximum testing, just in case, ok?

okay. I'll keep it out of my -next branch.

g.
