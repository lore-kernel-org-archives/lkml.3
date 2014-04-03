Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaDCPVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:21:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36614 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbaDCPVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:21:20 -0400
Message-ID: <533D7C4F.4010504@zytor.com>
Date: Thu, 03 Apr 2014 08:20:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Li, Aubrey" <aubrey.li@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [BUG] x86: reboot doesn't reboot
References: <20140403021411.6236996f@gandalf.local.home>	<070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>	<533D001A.5030802@linux.intel.com>	<20140403094155.04cc00bc@gandalf.local.home>	<533D6BE7.3020608@zytor.com>	<20140403104721.5f6c32b6@gandalf.local.home> <20140403111711.5bed4ff7@gandalf.local.home>
In-Reply-To: <20140403111711.5bed4ff7@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 08:17 AM, Steven Rostedt wrote:
> On Thu, 3 Apr 2014 10:47:21 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Thu, 03 Apr 2014 07:10:47 -0700
> 
>> Passed
>>
>>> reboot=a
> 
> After getting Matthew's email, I tried this again and it failed to
> boot. Let me rerun through the list again and I'll report back if
> things have changed.
> 
> Changing options, rebooting, changing options rebooting, gets a bit
> confusing. I may have rebooted the 'b' and thought it was the 'a'.
> 

Also, can you send the dmidecode from your system?  Is it a Dell?

	-hpa


