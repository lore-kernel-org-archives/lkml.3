Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3CALDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:03:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56950 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab3CALDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:03:20 -0500
Date: Fri, 1 Mar 2013 12:03:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Martin Bligh <mbligh@mbligh.org>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Don Morris <don.morris@hp.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com,
        tangchen@cn.fujitsu.com
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
Message-ID: <20130301110310.GA31058@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@mbligh.org>,
	Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Don Morris <don.morris@hp.com>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tony Luck <tony.luck@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	x86@kernel.org, a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com,
	tangchen@cn.fujitsu.com
References: <512B7D10.4060304@tpi.com>
 <512B8407.2090807@canonical.com>
 <512BD753.4080001@hp.com>
 <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
 <CAE9FiQXs3MyUW+hJhupJgL-t9sYmT5GdeStWD2vMjsJG+6qCrQ@mail.gmail.com>
 <CAE9FiQXHNm+E+PchPsReOykVPNkRrC8ttjDpWWs=njANT+Wf1Q@mail.gmail.com>
 <CAJErZ53dadbU3oM4Prhi3n_R+Lsbp3TG=FP1=whTK5uPMpj90A@mail.gmail.com>
 <CAE9FiQWx=FdQSH_H_PoVxUksY6rFnN6yDfwmK3w8OTbCPLM1+w@mail.gmail.com>
 <CAJErZ53AWMP688OV+J0qiJii2y=qzEjLq=WshAQbMhEdyx33cQ@mail.gmail.com>
 <51304C96.3010801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51304C96.3010801@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 10:37:10PM -0800, H. Peter Anvin wrote:
> I'd be very happy to get the NUMAQ code ripped out.  I am wondering if
> there are any reasons to keep any 32-bit x86 NUMA code at all.

How much would it hurt us if we said 3.8 is the last kernel that
supported NUMAQ? If anyone wants the functionality, they should use 3.8
or older.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
