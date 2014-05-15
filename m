Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaEOVu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:50:26 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:51981 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbaEOVuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:50:25 -0400
Message-ID: <53751321.7070905@linux.vnet.ibm.com>
Date: Fri, 16 May 2014 00:48:57 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org, mgorman@suse.de, riel@redhat.com, bp@suse.de,
        rostedt@goodmis.org, mgalbraith@suse.de, ego@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com> <20140515191338.19811.72313.stgit@srivatsabhat.in.ibm.com> <20140515191720.GA21306@htj.dyndns.org>
In-Reply-To: <20140515191720.GA21306@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051519-1618-0000-0000-0000003B0145
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 12:47 AM, Tejun Heo wrote:
> On Fri, May 16, 2014 at 12:43:44AM +0530, Srivatsa S. Bhat wrote:
>> During CPU offline, stop-machine is used to take control over all the online
>> CPUs (via the per-cpu stopper thread) and then run take_cpu_down() on the CPU
>> that is to be taken offline.
> ...
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> Reviewed-by: Tejun Heo <tj@kernel.org>
> 

Cool! Thanks a lot Tejun!
 
Regards,
Srivatsa S. Bhat

