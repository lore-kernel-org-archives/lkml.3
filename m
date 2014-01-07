Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaAGOd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:33:57 -0500
Received: from service87.mimecast.com ([91.220.42.44]:60241 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaAGOdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:33:36 -0500
Message-ID: <52CC1044.9040608@arm.com>
Date: Tue, 07 Jan 2014 14:33:40 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Redpath <Chris.Redpath@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 8/8] sched: remove scheduler domain naming
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com> <1386936688-29113-9-git-send-email-dietmar.eggemann@arm.com> <20131220140842.GW16438@laptop.programming.kicks-ass.net> <52CAF8D5.7010809@arm.com> <20140107102242.GQ30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140107102242.GQ30183@twins.programming.kicks-ass.net>
X-OriginalArrivalTime: 07 Jan 2014 14:33:32.0952 (UTC) FILETIME=[70FB0980:01CF0BB5]
X-MC-Unique: 114010714333408601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/14 10:22, Peter Zijlstra wrote:
> On Mon, Jan 06, 2014 at 06:41:25PM +0000, Dietmar Eggemann wrote:
>> But the MC level cpu mask func ptr is called cpu_coregroup_mask.
> 
> Nothing a bit of sed won't cure very quickly indeed :-)

True, but that would mean that if two adjacent levels use the same
cpu_foo_mask function, then their debug name would have to be the same.
AFAICS, sd_parent_degenerate() allows adjacent levels to have the same
cpu mask if the flags are different. Probably not a big deal.

> 


