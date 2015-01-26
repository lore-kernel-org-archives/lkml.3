Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbbAZSEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:04:24 -0500
Received: from outbound-smtp03.blacknight.com ([81.17.249.16]:36941 "EHLO
	outbound-smtp03.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755824AbbAZSEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:04:22 -0500
Message-ID: <54C681A5.8050701@nexus-software.ie>
Date: Mon, 26 Jan 2015 18:04:21 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] x86: Add Isolated Memory Regions for Quark X1000
References: <1422281727-32610-1-git-send-email-pure.logic@nexus-software.ie>	<1422281727-32610-2-git-send-email-pure.logic@nexus-software.ie>	<CAHp75VfAPjermaPYu2FwoRCycKsU48m=uXq=JqwQ6Bi31kV0hg@mail.gmail.com>	<54C67267.3060406@nexus-software.ie> <CAHp75VcgUuUkfq0+W-Q5ab0Jm_i9syzvD=gC+Qd0_SX9L2LVqA@mail.gmail.com>
In-Reply-To: <CAHp75VcgUuUkfq0+W-Q5ab0Jm_i9syzvD=gC+Qd0_SX9L2LVqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/15 17:23, Andy Shevchenko wrote:
>>> So, I'm not sure the above is a part of the patch. Would it be a prepend?
>> Hmm - what do you mean by that ?
>
> I mean first to introduce IMR files and then create the board entry in
> the kernel config.

OK so a patch in two parts ?

Works for me.

Will do @ V5
