Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936511Ab3DKPeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:34:03 -0400
Received: from intranet.asianux.com ([58.214.24.6]:51374 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934954Ab3DKPeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:34:01 -0400
X-Spam-Score: -100.8
Message-ID: <5166D7C5.6000404@asianux.com>
Date: Thu, 11 Apr 2013 23:33:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/3] posix-timers: Correctly get dying task time sample
 in posix_cpu_timer_schedule()
References: <1364649331-30940-1-git-send-email-fweisbec@gmail.com> <1364649331-30940-2-git-send-email-fweisbec@gmail.com> <5158CFDF.4060700@asianux.com> <20130411152656.GG15699@somewhere>
In-Reply-To: <20130411152656.GG15699@somewhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月11日 23:26, Frederic Weisbecker wrote:
> Bug reporters simply deserve to be credited, no sorting is required ;)
> 

  thank God.


>> > 
>> >   next, I should continue to try to find another issues about kernel.
> I encourage you to do so :)

  I will continue.

  :-)

-- 
Chen Gang

Asianux Corporation
