Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3H3P1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:27:48 -0400
Received: from www.sr71.net ([198.145.64.142]:43964 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab3H3P1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:27:46 -0400
Message-ID: <5220B9E4.3040306@sr71.net>
Date: Fri, 30 Aug 2013 08:27:32 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, mgorman@suse.de, hannes@cmpxchg.org,
        tony.luck@intel.com, matthew.garrett@nebula.com, riel@redhat.com,
        arjan@linux.intel.com, srinivas.pandruvada@linux.intel.com,
        willy@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org,
        rjw@sisk.pl, gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND RFC PATCH v3 00/35] mm: Memory Power Management
References: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 06:13 AM, Srivatsa S. Bhat wrote:
> Overview of Memory Power Management and its implications to the Linux MM
> ========================================================================
> 
> Today, we are increasingly seeing computer systems sporting larger and larger
> amounts of RAM, in order to meet workload demands. However, memory consumes a
> significant amount of power, potentially upto more than a third of total system
> power on server systems[4]. So naturally, memory becomes the next big target
> for power management - on embedded systems and smartphones, and all the way
> upto large server systems.

Srivatsa, you're sending a huge patch set to a very long cc list of
people, but you're leading the description with text that most of us
have already read a bunch of times.  Why?

What changed in this patch from the last round?  Where would you like
reviewers to concentrate their time amongst the thousand lines of code?
 What barriers do _you_ see as remaining before this gets merged?

