Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaCMWKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:10:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44707 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbaCMWKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:10:20 -0400
Message-ID: <53222C78.3020408@zytor.com>
Date: Thu, 13 Mar 2014 15:08:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>
CC: Andy Lutomirski <luto@amacapital.net>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Subject: Re: [PATCH 0/3] Improve 32 bit vDSO time
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>	 <CALCETrViaEdPsZO_xKaoihkNzayB+vhwpAO0YvNbfXZH2tOLUg@mail.gmail.com>	 <20140313001143.Horde.HpQnD8JBClJFZRY7b8BtnQ1@webmail.your-server.de>	 <53212A96.8020005@zytor.com> <1394698270.1008.19.camel@wall-e.seibold.net>
In-Reply-To: <1394698270.1008.19.camel@wall-e.seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 01:11 AM, Stefani Seibold wrote:
> Am Mittwoch, den 12.03.2014, 20:48 -0700 schrieb H. Peter Anvin:
>> On 03/12/2014 04:11 PM, stefani@seibold.net wrote:
>>>
>>> I will do this when your patch is pulled into tip. For now we have the
>>> choice, but i preferer our solution removing the compat vdso.
>>>
>>
>> Sorry, that didn't parse from me.
> 
> I thought it is a good idea to wait until the "remove compat vdso
> support" is settled and pulled into tip.
> 
> If there is no objections against this patch i am happy to do the
> job ;-)
> 
> BTW: Thanks to Andy for doing this job to git rid off this ugly compat
> vDSO layer.
> 
>> Also, if you state a preference, could you please motivate it?
> 
> For the next three days i am very busy with a important project, so i
> will rebase the vdso 32 bit time patch on Monday or Tuesday. 
> 

So when I get the updated patch from Andy I will pull it into tip,
resetting the x86/vdso branch.  I'll then expect an upgraded and
simplified patchset from you to put on top.

Sounds like a plan.

	-hpa


