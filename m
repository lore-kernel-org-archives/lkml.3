Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3AKVmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:42:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab3AKVml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:42:41 -0500
Message-ID: <50F08749.2020306@redhat.com>
Date: Fri, 11 Jan 2013 13:42:33 -0800
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: oleg@redhat.com, srikar@linux.vnet.ibm.com, mingo@kernel.org,
        peterz@infradead.org, anton@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Add exports for module use
References: <1357858906-9711-1-git-send-email-jistone@redhat.com> <20130111093227.GA30043@infradead.org>
In-Reply-To: <20130111093227.GA30043@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 01/11/2013 01:32 AM, Christoph Hellwig wrote:
> On Thu, Jan 10, 2013 at 03:01:46PM -0800, Josh Stone wrote:
>> The original pull message for uprobes (commit 654443e2) noted:
>>
>>   This tree includes uprobes support in 'perf probe' - but SystemTap
>>   (and other tools) can take advantage of user probe points as well.

I believe this quoted line already signaled the intent that SystemTap
use should be allowed.

> Get systemtap into the mainline kernel tree and we can talk.

This is unlikely to ever happen, nor do I think it's necessarily
appropriate.  For instance, we are also developing an alternate mode of
operation that uses Dyninst instead of kernel modules.  We're keeping
both modes for their different trade-offs, but in general the tool's
relationship with the kernel is somewhat weaker now.

Thanks,
Josh

