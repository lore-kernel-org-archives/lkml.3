Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761553AbbA2KM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:12:27 -0500
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:59283 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932615AbbA2KMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:12:22 -0500
Message-ID: <54CA0782.8000807@nexus-software.ie>
Date: Thu, 29 Jan 2015 10:12:18 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
References: <1422470186-7860-1-git-send-email-pure.logic@nexus-software.ie>	<1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie>	<20150129074411.GA4817@gmail.com> <CAHp75Vfff-C++LWyyK+FWLnot=jO4kQvbDaN9hJ2_VrhG8n2Qg@mail.gmail.com>
In-Reply-To: <CAHp75Vfff-C++LWyyK+FWLnot=jO4kQvbDaN9hJ2_VrhG8n2Qg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/15 10:08, Andy Shevchenko wrote:
> On Thu, Jan 29, 2015 at 9:44 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> * Bryan O'Donoghue <pure.logic@nexus-software.ie> wrote:
>
> []
>
>> In any case, I don't see any major problems with this code, so if
>> it's fixed it could go into v3.20.
>
> Brian, it would be really nice to have it in 3.20 since we have
> several drivers already in upstream or be ready for 3.20.
> It would be then first upstream kernel with minimal Quark support.

NP lads - I'll get a patch out today

