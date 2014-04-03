Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaDCOL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:11:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35890 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbaDCOL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:11:28 -0400
Message-ID: <533D6BE7.3020608@zytor.com>
Date: Thu, 03 Apr 2014 07:10:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        "Li, Aubrey" <aubrey.li@linux.intel.com>
CC: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [BUG] x86: reboot doesn't reboot
References: <20140403021411.6236996f@gandalf.local.home>	<070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>	<533D001A.5030802@linux.intel.com> <20140403094155.04cc00bc@gandalf.local.home>
In-Reply-To: <20140403094155.04cc00bc@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 06:41 AM, Steven Rostedt wrote:
> On Thu, 03 Apr 2014 14:30:50 +0800
> "Li, Aubrey" <aubrey.li@linux.intel.com> wrote:
> 
> 
>> May I know if "reboot=t" make any difference on your system with the change?
> 
> Is this the future fix? Or do you have patches for me to test. I'll be
> happy to test any patches you have on this box. If you need to know
> anything about this box, let me know and I'll run any command that
> would help you.
> 

Could you tell which of these modes work on your box:

reboot=t
reboot=k
reboot=b	(BIOS only)
reboot=a
reboot=e	(EFI only)
reboot=p

	-hpa


