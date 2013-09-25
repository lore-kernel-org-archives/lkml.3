Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab3IYXlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:41:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3IYXk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:40:59 -0400
Date: Wed, 25 Sep 2013 16:40:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: mgorman@suse.de, dave@sr71.net, hannes@cmpxchg.org, tony.luck@intel.com,
        matthew.garrett@nebula.com, riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl,
        gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [Results] [RFC PATCH v4 00/40] mm: Memory Power Management
Message-Id: <20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org>
In-Reply-To: <52437128.7030402@linux.vnet.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
	<52437128.7030402@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013 04:56:32 +0530 "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> Experimental Results:
> ====================
> 
> Test setup:
> ----------
> 
> x86 Sandybridge dual-socket quad core HT-enabled machine, with 128GB RAM.
> Memory Region size = 512MB.

Yes, but how much power was saved ;)

Also, the changelogs don't appear to discuss one obvious downside: the
latency incurred in bringing a bank out of one of the low-power states
and back into full operation.  Please do discuss and quantify that to
the best of your knowledge.


