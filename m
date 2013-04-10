Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937204Ab3DJR7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:59:19 -0400
Received: from mail.candelatech.com ([208.74.158.172]:36048 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934904Ab3DJR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:59:18 -0400
Message-ID: <5165A874.50804@candelatech.com>
Date: Wed, 10 Apr 2013 10:59:16 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Jitter and latency benchmarks with netlink / nl80211
References: <CAB=NE6XH8wGbFhmB54Y0BUB2N-PbzUBvN+arH5F_BAkEa=DjUw@mail.gmail.com>
In-Reply-To: <CAB=NE6XH8wGbFhmB54Y0BUB2N-PbzUBvN+arH5F_BAkEa=DjUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 10:55 AM, Luis R. Rodriguez wrote:
> Curious if anyone has worked on latency and jitter benchmarks in using
> netlink, specifically with nl80211. Has anyone benchmarked this? Ben,
> have you? If not for nl80211 perhaps this has been done before for
> other netlink families?

You mean timing related to netlink configuration/report requests?

We have lots of ways to measure wifi packet throughput latencies
and jitter (to/from userspace and/or to/from pktgen), but it doesn't use
netlink....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

