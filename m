Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3APMwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:52:08 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58004 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3APMwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:52:06 -0500
X-AuditID: 9c930179-b7b54ae000000e44-47-50f6a274089d
From: Namhyung Kim <namhyung@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan\@linux.intel.com" <arjan@linux.intel.com>,
        "bp\@alien8.de" <bp@alien8.de>, "pjt\@google.com" <pjt@google.com>,
        "efault\@gmx.de" <efault@gmx.de>,
        "vincent.guittot\@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti\@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 17/22] sched: packing small tasks in wake/exec balancing
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
	<1357375071-11793-18-git-send-email-alex.shi@intel.com>
	<20130110171728.GG2046@e103034-lin> <50EF8B37.7050404@intel.com>
	<87pq18nsnk.fsf@sejong.aot.lge.com> <50F644A9.3080509@intel.com>
Date: Wed, 16 Jan 2013 21:52:04 +0900
In-Reply-To: <50F644A9.3080509@intel.com> (Alex Shi's message of "Wed, 16 Jan
	2013 14:11:53 +0800")
Message-ID: <871udlmgsr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 14:11:53 +0800, Alex Shi wrote:
> On 01/14/2013 03:13 PM, Namhyung Kim wrote:
>> On Fri, 11 Jan 2013 11:47:03 +0800, Alex Shi wrote:
>>> Um, change to leader_cpu?
>> 
>> vacantest? ;-)
>
> hard to the ward in google. are you sure it is better than leader_cpu?  :)

Nop.  My English is just bad. :)

But I'm not sure the "leader" is the right one.  Why is it called
"leader" in the first place?

Thanks,
Namhyung
