Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbaAWOwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:52:11 -0500
Received: from loki.mindstab.net ([69.164.214.81]:44575 "EHLO loki.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753817AbaAWOwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:52:08 -0500
Message-ID: <52E12C93.1050000@mindstab.net>
Date: Thu, 23 Jan 2014 06:52:03 -0800
From: Dan Ballard <dan@mindstab.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Lennart Poettering <lennart@poettering.net>, kay.sievers@vrfy.org,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minto Joseph <mvaliyav@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mgorman@suse.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] add StartTimeMonotomic, StartTimeBootTime to per
 pid in   /proc
References: <a24256fcec0f1735512ee303ce8abbdc@mindstab.net> <20140122155351.GV13532@twins.programming.kicks-ass.net>
In-Reply-To: <20140122155351.GV13532@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On request of Lennart Poettering for the Linux plumbers.

On 14-01-22 07:53 AM, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 07:10:04AM -0800, Dan Ballard wrote:
>> starttime in /proc/$PID/stat is inaccurate by "clock tick" granularity.
>> The kernel keeps better track os this exposes that in /prod/$PID/status
>> as StartTimeMonotonic and StartTimeBootTime
>>
> Why?

