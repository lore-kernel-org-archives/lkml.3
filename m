Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaGQHrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:47:16 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaGQHrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:47:15 -0400
Message-ID: <53C77F79.2010508@nod.at>
Date: Thu, 17 Jul 2014 09:47:05 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ia64: Remove Linux/x86 domain support
References: <1405263538-27589-1-git-send-email-richard@nod.at>	<1405263538-27589-3-git-send-email-richard@nod.at> <CA+8MBbKA5UppTjLP6JYAeLMAyeUPBfF73j91xDCfoF_Vewy5=A@mail.gmail.com>
In-Reply-To: <CA+8MBbKA5UppTjLP6JYAeLMAyeUPBfF73j91xDCfoF_Vewy5=A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.07.2014 01:20, schrieb Tony Luck:
> On Sun, Jul 13, 2014 at 7:58 AM, Richard Weinberger <richard@nod.at> wrote:
> 
> Did you read the comment?

Sure, please see my comment below.

>> -/*
>> - * Even when CONFIG_IA32_SUPPORT is not enabled it is
>> - * useful to have the Linux/x86 domain registered to
>> - * avoid an attempted module load when emulators call
>> - * personality(PER_LINUX32). This saves several milliseconds
>> - * on each such call.
>> - */
> 
> I don't know if there are still people using ia32el to run x86 binaries
> on ia64 ... but if there are, they may be sad at the extra delays.

As written in 0/, the plan is to get rid of exec domains at all.
Therefore personality(PER_LINUX32) would no longer try to request a module.

Thanks,
//richard
