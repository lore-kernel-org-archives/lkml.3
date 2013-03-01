Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab3CAGix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:38:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45547 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab3CAGiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:38:52 -0500
Message-ID: <51304C96.3010801@zytor.com>
Date: Thu, 28 Feb 2013 22:37:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Martin Bligh <mbligh@mbligh.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Don Morris <don.morris@hp.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com,
        tangchen@cn.fujitsu.com
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXs3MyUW+hJhupJgL-t9sYmT5GdeStWD2vMjsJG+6qCrQ@mail.gmail.com> <CAE9FiQXHNm+E+PchPsReOykVPNkRrC8ttjDpWWs=njANT+Wf1Q@mail.gmail.com> <CAJErZ53dadbU3oM4Prhi3n_R+Lsbp3TG=FP1=whTK5uPMpj90A@mail.gmail.com> <CAE9FiQWx=FdQSH_H_PoVxUksY6rFnN6yDfwmK3w8OTbCPLM1+w@mail.gmail.com> <CAJErZ53AWMP688OV+J0qiJii2y=qzEjLq=WshAQbMhEdyx33cQ@mail.gmail.com>
In-Reply-To: <CAJErZ53AWMP688OV+J0qiJii2y=qzEjLq=WshAQbMhEdyx33cQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2013 08:51 PM, Martin Bligh wrote:
>> Do you mean we can remove numaq x86 32bit code now?
> 
> Wouldn't bother me at all. The machine is from 1995, end of life c. 2000?
> Was useful in the early days of getting NUMA up and running on Linux,
> but is now too old to be a museum piece, really.
> 

I'd be very happy to get the NUMAQ code ripped out.  I am wondering if
there are any reasons to keep any 32-bit x86 NUMA code at all.

	-hpa


