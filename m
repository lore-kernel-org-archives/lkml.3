Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbaAaPmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:42:44 -0500
Received: from loki.mindstab.net ([69.164.214.81]:55339 "EHLO loki.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932310AbaAaPmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:42:42 -0500
To: Peter Zijlstra <peterz@infradead.org>, kay.sievers@vrfy.org,
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
Subject: Re: [PATCH 1/1] add StartTimeMonotomic, StartTimeBootTime to per  pid in   /proc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 31 Jan 2014 07:42:40 -0800
From: Dan Ballard <dan@mindstab.net>
In-Reply-To: <20140124113203.GZ30183@twins.programming.kicks-ass.net>
References: <a24256fcec0f1735512ee303ce8abbdc@mindstab.net>
 <20140122155351.GV13532@twins.programming.kicks-ass.net>
 <20140124102037.GE4870@tango.0pointer.de>
 <20140124113203.GZ30183@twins.programming.kicks-ass.net>
Message-ID: <d7f132a9ede3ce67d74f899a66cdaf86@mindstab.net>
User-Agent: Roundcube Webmail/0.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The process starttime is useful for a variety of things, like figuring
>> out creation ordering of processes. Or it is useful to detect PID
>> reuses in a somewhat reliable way.
> 
> OK, maybe. Changelog should have said so.
> 
> Yeah, Dan was also too lazy to explain the need, and had like 3 typoes
> in the inadequate changelog he had.
> 
> Does not inspire confidence.
> 
> Now please all untwist your panties and try and submit a proper patch.

Resubmitted with more explanation (and less typos). If you feel that 
having
both CLOCK_MONOTONIC and CLOCK_BOOTTIME is really a sticking point I'd 
be
ok to remove one as long as the other made it through, as one is much 
better
than none.
