Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbaFPVmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:42:05 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46624 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbaFPVmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:42:03 -0400
Message-ID: <539F6476.5010403@oracle.com>
Date: Mon, 16 Jun 2014 17:41:10 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, paulus@samba.org, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: perf/workqueue: lockdep warning on process exit
References: <539EFE3A.7020700@oracle.com>
In-Reply-To: <539EFE3A.7020700@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 10:24 AM, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:

I think that this is due to a recent change, since it seems to reproduce very
often. I've tried bisecting it but it seems that I'm hitting unrelated issues
and can't correctly run the bisection.


Thanks,
Sasha
