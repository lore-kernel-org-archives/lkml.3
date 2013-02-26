Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3BZDV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:21:58 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:56273 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3BZDV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:21:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXHNm+E+PchPsReOykVPNkRrC8ttjDpWWs=njANT+Wf1Q@mail.gmail.com>
References: <512B7D10.4060304@tpi.com>
	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
	<CAE9FiQXs3MyUW+hJhupJgL-t9sYmT5GdeStWD2vMjsJG+6qCrQ@mail.gmail.com>
	<CAE9FiQXHNm+E+PchPsReOykVPNkRrC8ttjDpWWs=njANT+Wf1Q@mail.gmail.com>
Date: Mon, 25 Feb 2013 22:21:56 -0500
Message-ID: <CAJErZ53dadbU3oM4Prhi3n_R+Lsbp3TG=FP1=whTK5uPMpj90A@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Martin Bligh <mbligh@mbligh.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com,
        tangchen@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> 4, it does not CC to TJ and other numa guys...
>>
>> attached workaround the problem for now.
>> but it will assume NUMAQ would not have SRAT table.
>
>  Martin, can you confirm that numaq does not have srat?

No, it's pre-SRAT. I forget the exact name of the table, but no SRAT until x440.

OTOH, you should probably feel free to break it by now, I can't
imagine they are any use to man nor beast any more.

M.
