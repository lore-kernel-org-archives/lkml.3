Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3CAPee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:34:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54075 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab3CAPec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:34:32 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130301112432.GA3018@gmail.com>
References: <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXs3MyUW+hJhupJgL-t9sYmT5GdeStWD2vMjsJG+6qCrQ@mail.gmail.com> <CAE9FiQXHNm+E+PchPsReOykVPNkRrC8ttjDpWWs=njANT+Wf1Q@mail.gmail.com> <CAJErZ53dadbU3oM4Prhi3n_R+Lsbp3TG=FP1=whTK5uPMpj90A@mail.gmail.com> <CAE9FiQWx=FdQSH_H_PoVxUksY6rFnN6yDfwmK3w8OTbCPLM1+w@mail.gmail.com> <CAJErZ53AWMP688OV+J0qiJii2y=qzEjLq=WshAQbMhEdyx33cQ@mail.gmail.com> <51304C96.3010801@zytor.com> <20130301110310.GA31058@pd.tnic> <20130301112432.GA3018@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 01 Mar 2013 07:32:48 -0800
To: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Martin Bligh <mbligh@mbligh.org>, Yinghai Lu <yinghai@kernel.org>,
        Don Morris <don.morris@hp.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com,
        tangchen@cn.fujitsu.com
Message-ID: <6d811f43-e966-4885-9a2e-30b0b71466e0@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NUMAQ is breaking real stuff we can kill it by marking it BROKEN.  Rip-out is 3.10 at this stage.

Ingo Molnar <mingo@kernel.org> wrote:

>
>* Borislav Petkov <bp@alien8.de> wrote:
>
>> On Thu, Feb 28, 2013 at 10:37:10PM -0800, H. Peter Anvin wrote:
>> > I'd be very happy to get the NUMAQ code ripped out.  I am wondering
>if
>> > there are any reasons to keep any 32-bit x86 NUMA code at all.
>> 
>> How much would it hurt us if we said 3.8 is the last kernel that
>supported NUMAQ? 
>> If anyone wants the functionality, they should use 3.8 or older.
>
>v3.9 - any non-trivial patch in the stage of being contemplated near
>the end of the 
>v3.9 merge window is most likely v3.10 material.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
