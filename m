Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaBNO1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:27:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbaBNO1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:27:51 -0500
Message-ID: <52FE2785.7090701@redhat.com>
Date: Fri, 14 Feb 2014 09:26:13 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, paulus@samba.org,
        oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
CC: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Toshi Kani <toshi.kani@hp.com>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 49/52] mm, vmstat: Fix CPU hotplug callback registration
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com> <20140214080017.22701.62427.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214080017.22701.62427.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 03:00 AM, Srivatsa S. Bhat wrote:
> Subsystems that want to register CPU hotplug callbacks, as well as perform
> initialization for the CPUs that are already online, often do it as shown
> below:

> Fix the vmstat code in the MM subsystem by using this latter form of callback
> registration.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
> Cc: Toshi Kani <toshi.kani@hp.com>
> Cc: Dave Hansen <dave@sr71.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: linux-mm@kvack.org
> Acked-by: Christoph Lameter <cl@linux.com>
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
