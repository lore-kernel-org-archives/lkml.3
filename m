Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaEAAl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:41:28 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:56481 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbaEAAl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:41:27 -0400
Message-ID: <5361982F.3080307@linaro.org>
Date: Thu, 01 May 2014 08:41:19 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, efault@gmx.de, wangyun@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: Re: [RESEND PATCH V5 0/8] remove cpu_load idx
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org> <20140424162029.GV11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140424162029.GV11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


于 4/25/14, 0:20, Peter Zijlstra 写道:
>
> OK, this series is a lot saner, with the exception of 3/8 and
> dependents.
>
> I do still worry a bit for loosing the longer term view for the big
> domains though. Sadly I don't have any really big machines.
>
> I think the entire series is equivalent to setting LB_BIAS to false. So
> I suppose we could do that for a while and if nobody reports horrible
> things we could just do this.

Very sorry for over look this email!

Yes, it is a good idea to try false LB_BIAS first.
>
> Anybody?

