Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaDDMfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:35:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47919 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbaDDMfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:35:30 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140404061332.GA11877@gmail.com>
References: <533D7C93.7080105@zytor.com> <20140403113921.23dceb75@gandalf.local.home> <533D8516.1040803@zytor.com> <20140403121314.246b03a7@gandalf.local.home> <533DED74.6050202@linux.intel.com> <20140403194018.7c67aec7@gandalf.local.home> <533DF455.4040908@linux.intel.com> <533DF8D2.9060508@zytor.com> <533E0A94.5040007@linux.intel.com> <091fb6ee-a7e1-4962-9382-7e3b14792797@email.android.com> <20140404061332.GA11877@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [BUG] x86: reboot doesn't reboot
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 04 Apr 2014 05:34:39 -0700
To: Ingo Molnar <mingo@kernel.org>
CC: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Message-ID: <86edd315-bbea-47a5-b228-95326de8aff0@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plenty.  It used to be the default reboot method for a long time, but it isn't anymore for a reason.

On April 3, 2014 11:13:32 PM PDT, Ingo Molnar <mingo@kernel.org> wrote:
>
>* H. Peter Anvin <hpa@zytor.com> wrote:
>
>> Keep in mind we already tried CF9 in the default flow and it broke 
>> things.  I'm willing to wait for reports about production machines, 
>> though, but I fully expect them.
>
>Typically there's nothing particularly weird about preproduction Intel 
>hardware when it comes to reboot methods, other than people more 
>willing to test them with development kernels.
>
>Is there any system were the triple fault method does not work?
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
