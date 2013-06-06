Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3FFVd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:33:28 -0400
Received: from mail.candelatech.com ([208.74.158.172]:55476 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3FFVd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:33:27 -0400
Message-ID: <51B10023.3050400@candelatech.com>
Date: Thu, 06 Jun 2013 14:33:23 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH v2] Fix lockup related to stop_machine being stuck in
 __do_softirq.
References: <1370535006-3467-1-git-send-email-greearb@candelatech.com> <20130606204821.GB5045@htj.dyndns.org>
In-Reply-To: <20130606204821.GB5045@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 01:48 PM, Tejun Heo wrote:

> As wrote before, a brief explanation on why both are necessary would
> be nice.  Something like - "the time limit prevents from introducing
> excessive latency from softirq handling and the loop limit protects
> against softirq runaway which may happen during stop_machine - see
> XXX".
>
> Please cc Linus and also cc stable@vger.kernel.org.  We definitely
> want this backported.

v3 was sent, with updated comments and expanded CC list.

The patch is against 3.9.4, though I assume it will apply
to the upstream kernel easily enough.

I didn't want to add a link to the email thread..  The commit message
and patch has enough info that I think an interested party could find
the email thread easily enough if they needed more history.

And, much of the email thread is me running in circles thinking
I am going insane :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

