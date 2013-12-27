Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3L0QO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 11:14:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab3L0QO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 11:14:27 -0500
Message-ID: <52BDA759.3000907@redhat.com>
Date: Fri, 27 Dec 2013 11:14:17 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: rui wang <ruiv.wang@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Michel Lespinasse <walken@google.com>,
        Andi Kleen <ak@linux.intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        tony.luck@intel.com
Subject: Re: [PATCH] x86, Fix do_IRQ interrupt warning for cpu hotplug retriggered
 irqs
References: <1385990638-19548-1-git-send-email-prarit@redhat.com>	<CANVTcTZ-ZkTvR0+=eFyNQ7E8R2UYo1qdA-RQ+9nzK2w=qCPkPQ@mail.gmail.com>	<52B856D3.4030802@redhat.com>	<CANVTcTb8SJKriUeRb9pxNiqAkwxO4p0N1-M3krHGeLduHsqrEQ@mail.gmail.com>	<52B9881E.4090702@redhat.com> <CANVTcTb+1+03mRzyO7r1=OTkrocdZC2hY8YWoxE9vmfYEbS_cA@mail.gmail.com>
In-Reply-To: <CANVTcTb+1+03mRzyO7r1=OTkrocdZC2hY8YWoxE9vmfYEbS_cA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/25/2013 03:22 AM, rui wang wrote:
> 
> Yes that comment was what triggered me to think that the issue wasn't
> understood. You now have a clear enough explanation.
> 

Rui, you've pointed out that my patch description in insufficient.  I'll rewrite
it and resubmit with a much more detailed description.

P.

> Thanks
> Rui
