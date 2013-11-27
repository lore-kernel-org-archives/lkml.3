Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3K0G0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:26:24 -0500
Received: from relay.parallels.com ([195.214.232.42]:42117 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3K0G0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:26:23 -0500
Message-ID: <52959089.6030607@parallels.com>
Date: Wed, 27 Nov 2013 10:26:17 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, <akpm@linux-foundation.org>,
        <mhocko@suse.cz>, <glommer@openvz.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH v11 00/15] kmemcg shrinkers
References: <cover.1385377616.git.vdavydov@parallels.com> <20131125174135.GE22729@cmpxchg.org> <529443E4.7080602@parallels.com> <20131126224742.GB10988@dastard>
In-Reply-To: <20131126224742.GB10988@dastard>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.24.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 02:47 AM, Dave Chinner wrote:
> On Tue, Nov 26, 2013 at 10:47:00AM +0400, Vladimir Davydov wrote:
>> Hi,
>>
>> Thank you for the review. I agree with all your comments and I'll
>> resend the fixed version soon.
>>
>> If anyone still has something to say about the patchset, I'd be glad
>> to hear from them.
> Please CC me on all the shrinker/list-lru changes being made as I am
> the original author of the list-lru code and the shrinker
> integration and have more than a passing interest in ensuring
> it doesn't get broken or crippled....

Sure, thanks.
