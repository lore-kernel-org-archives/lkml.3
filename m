Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbbAXV6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 16:58:51 -0500
Received: from outbound-smtp03.blacknight.com ([81.17.249.16]:34192 "EHLO
	outbound-smtp03.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbbAXV6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 16:58:49 -0500
Message-ID: <54C41598.5080801@nexus-software.ie>
Date: Sat, 24 Jan 2015 21:58:48 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark X1000
References: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie>	<1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie>	<AF233D1473C1364ABD51D28909A1B1B73270D4C5@PGSMSX105.gar.corp.intel.com> <CAHp75VcCcpUZ7AuKk96-aVUd6Vykfc8_yod+8T_at2DMuTve3Q@mail.gmail.com> <54C4151D.2080306@nexus-software.ie>
In-Reply-To: <54C4151D.2080306@nexus-software.ie>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/15 21:56, Bryan O'Donoghue wrote:
>>>> +
>>>> +                      if ((imr_to_phys(imr.addr_lo) == base) &&
>>>> +                          (imr_to_phys(imr.addr_hi) == max)) {
>>> I think we need to take care of the size that has been fix-up here ...
>>>
>>>> +                              found = 1;
>>>> +                              reg = i;
>>
>> According to your comment this line becomes redundant.
>>
>
> Ah but I still think though.

"Ah but I still think *I'll keep* that though

:)

> We eventually do an imr_write(reg, &imr); which I think reads better
> than imr_write(i, &imr);
>
> --
> BOD

