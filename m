Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754Ab3BZEUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:20:21 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:51951 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759712Ab3BZEUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:20:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAJErZ53dadbU3oM4Prhi3n_R+Lsbp3TG=FP1=whTK5uPMpj90A@mail.gmail.com>
References: <512B7D10.4060304@tpi.com>
	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
	<CAE9FiQXs3MyUW+hJhupJgL-t9sYmT5GdeStWD2vMjsJG+6qCrQ@mail.gmail.com>
	<CAE9FiQXHNm+E+PchPsReOykVPNkRrC8ttjDpWWs=njANT+Wf1Q@mail.gmail.com>
	<CAJErZ53dadbU3oM4Prhi3n_R+Lsbp3TG=FP1=whTK5uPMpj90A@mail.gmail.com>
Date: Mon, 25 Feb 2013 20:20:19 -0800
X-Google-Sender-Auth: ZJBkV4_Mbr2JzCOtj5qLFFr-wyM
Message-ID: <CAE9FiQWx=FdQSH_H_PoVxUksY6rFnN6yDfwmK3w8OTbCPLM1+w@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>
Cc: Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com,
        tangchen@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 7:21 PM, Martin Bligh <mbligh@mbligh.org> wrote:
>>>> 4, it does not CC to TJ and other numa guys...
>>>
>>> attached workaround the problem for now.
>>> but it will assume NUMAQ would not have SRAT table.
>>
>>  Martin, can you confirm that numaq does not have srat?
>
> No, it's pre-SRAT. I forget the exact name of the table, but no SRAT until x440.
>
> OTOH, you should probably feel free to break it by now, I can't
> imagine they are any use to man nor beast any more.

Do you mean we can remove numaq x86 32bit code now?

Thanks

Yinghai
