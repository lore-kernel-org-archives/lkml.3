Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbbA2PW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:22:26 -0500
Received: from outbound-smtp04.blacknight.com ([81.17.249.35]:42717 "EHLO
	outbound-smtp04.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140AbbA2PWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:22:25 -0500
Message-ID: <54CA502D.9030307@nexus-software.ie>
Date: Thu, 29 Jan 2015 15:22:21 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Ong, Boon Leong" <boon.leong.ong@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
References: <1422470186-7860-1-git-send-email-pure.logic@nexus-software.ie>	<1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie>	<20150129074411.GA4817@gmail.com> <CAHp75Vfff-C++LWyyK+FWLnot=jO4kQvbDaN9hJ2_VrhG8n2Qg@mail.gmail.com> <54CA0782.8000807@nexus-software.ie> <AF233D1473C1364ABD51D28909A1B1B7327158BE@PGSMSX105.gar.corp.intel.com>
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B7327158BE@PGSMSX105.gar.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/15 13:47, Ong, Boon Leong wrote:
> Bryan,
>
> Once you have the next revision ready, I would like to test it on my end across both Galileo Gen v1 & v2.
>
> Cheers,
> BL

Andy/BL - thanks for taking the time to test.

I may end up dropping the imr_del_range() tests based on index as a 
result of changing the external interface as suggested by Ingo.

If you guys have a clear preference to keep those tests shout now and 
I'll re-merge the imr_selftest code into the main chunk of IMR code.

--
BOD

