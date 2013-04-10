Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936636Ab3DJSGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:06:05 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:40565 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934826Ab3DJSGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:06:02 -0400
MIME-Version: 1.0
In-Reply-To: <5165A874.50804@candelatech.com>
References: <CAB=NE6XH8wGbFhmB54Y0BUB2N-PbzUBvN+arH5F_BAkEa=DjUw@mail.gmail.com>
 <5165A874.50804@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 10 Apr 2013 11:05:40 -0700
X-Google-Sender-Auth: x6zgu58SgH6lCkBNjM1nQDRYufw
Message-ID: <CAB=NE6U_0E+y8jc_0O3+9pmUyLXX9CuSMYMMWk__4Q8-+-AHTg@mail.gmail.com>
Subject: Re: Jitter and latency benchmarks with netlink / nl80211
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 10:59 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 04/10/2013 10:55 AM, Luis R. Rodriguez wrote:
>>
>> Curious if anyone has worked on latency and jitter benchmarks in using
>> netlink, specifically with nl80211. Has anyone benchmarked this? Ben,
>> have you? If not for nl80211 perhaps this has been done before for
>> other netlink families?
>
>
> You mean timing related to netlink configuration/report requests?

Yes.

> We have lots of ways to measure wifi packet throughput latencies
> and jitter (to/from userspace and/or to/from pktgen), but it doesn't use
> netlink....

Not looking for latency / jitter for 802.11, but for the core nl80211 messages.

  Luis
