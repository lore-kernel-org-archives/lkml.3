Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3JQMey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:34:54 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58375 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab3JQMew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:34:52 -0400
Message-ID: <525FD2FA.8010403@linux.vnet.ibm.com>
Date: Thu, 17 Oct 2013 17:37:22 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Tony Luck <tony.luck@gmail.com>, Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: Extended H/W error log driver
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com> <20131011080427.GC18719@pd.tnic> <20131014064940.GD12189@gchen.bj.intel.com> <20131014105533.GF4009@pd.tnic> <20131015040731.GA887@gchen.bj.intel.com> <20131015092851.GA7908@pd.tnic> <CA+8MBbJeSJBDPcomupOuVBrnZNkMTNTXsoZY9yUbXPe9YrTFXg@mail.gmail.com> <20131015191040.GA4347@naverao1-tp.ibm.com> <20131015192353.GI7908@pd.tnic>
In-Reply-To: <20131015192353.GI7908@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101712-1618-0000-0000-000004D17DE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 12:53 AM, Borislav Petkov wrote:
> On Wed, Oct 16, 2013 at 12:40:40AM +0530, Naveen N. Rao wrote:
>> +2 ;)
>
> You're counting for 2 people, huh?

That's me raising both my hands :)

>
> :-)
>
>> While at it, I wonder if we're better off calling these "Hardware
>> events" rather than "Hardware errors".
>
> Oh, please no. That's that euphemistic lying which serves no one. And
> here's what I mean by "euphemistic lying":
>
> https://www.youtube.com/watch?v=vuEQixrBKCc
>
> Let's call it what it really is but, at the same time, make sure it is
> understandable to users what action they need to undertake (or none)
> when they encounter it.

If you feel so strongly about it. "Corrected Error" is an oxymoron. It's 
really just the hardware notifying us.


Thanks,
Naveen

