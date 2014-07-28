Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaG1Tzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:55:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40891 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaG1Tzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:55:48 -0400
Message-ID: <53D6AA9F.6090806@oracle.com>
Date: Mon, 28 Jul 2014 15:55:11 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf: invalid memory access in perf_swevent_del
References: <536EB79C.2080308@oracle.com> <53D313A3.2090201@oracle.com> <20140728170406.GV6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140728170406.GV6758@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 01:04 PM, Peter Zijlstra wrote:
> Does your trinity do hotplug while creating/destroying events?

It might write to random /sysfs files, I've seen it do hotplugs of
about everything possible.


Thanks,
Sasha
