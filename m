Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaDCXXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:23:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:22026 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbaDCXXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:23:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,791,1389772800"; 
   d="scan'208";a="514447854"
Message-ID: <533DED74.6050202@linux.intel.com>
Date: Fri, 04 Apr 2014 07:23:32 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [BUG] x86: reboot doesn't reboot
References: <20140403021411.6236996f@gandalf.local.home>	<070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>	<533D001A.5030802@linux.intel.com>	<20140403094155.04cc00bc@gandalf.local.home>	<533D6BE7.3020608@zytor.com>	<20140403104721.5f6c32b6@gandalf.local.home>	<20140403111711.5bed4ff7@gandalf.local.home>	<533D7C4F.4010504@zytor.com>	<533D7C93.7080105@zytor.com>	<20140403113921.23dceb75@gandalf.local.home>	<533D8516.1040803@zytor.com> <20140403121314.246b03a7@gandalf.local.home>
In-Reply-To: <20140403121314.246b03a7@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/4 0:13, Steven Rostedt wrote:
> On Thu, 03 Apr 2014 08:58:14 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> On 04/03/2014 08:39 AM, Steven Rostedt wrote:
>>>
>>> Hmm, I didn't see this email. Note, this box is an old development box
>>> that Intel sent me years ago.
>>>
>>
>> Preproduction system?
>>
> 
> Could be. Honestly, I don't remember. I use to get boxes from Intel and
> AMD randomly at my doorstep. Sometimes, a representative would actually
> tell me why I got it. I just took them and set them up in my test
> environment. Never really questioned why. I think these boxes are from
> 2006 or 2007.
> 

Can you please send the dmi table out?

Thanks,
-Aubrey
