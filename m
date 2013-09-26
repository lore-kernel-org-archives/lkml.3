Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3IZBVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:21:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3IZBVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:21:31 -0400
Date: Wed, 25 Sep 2013 18:21:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mgorman@suse.de,
        dave@sr71.net, hannes@cmpxchg.org, tony.luck@intel.com,
        matthew.garrett@nebula.com, riel@redhat.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl,
        gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        santosh.shilimkar@ti.com, kosaki.motohiro@gmail.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Results] [RFC PATCH v4 00/40] mm: Memory Power Management
Message-Id: <20130925182129.a7db6a0fd2c7cc3b43fda92d@linux-foundation.org>
In-Reply-To: <52438AA9.3020809@linux.intel.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
	<52437128.7030402@linux.vnet.ibm.com>
	<20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org>
	<20130925234734.GK18242@two.firstfloor.org>
	<52438AA9.3020809@linux.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 18:15:21 -0700 Arjan van de Ven <arjan@linux.intel.com> wrote:

> On 9/25/2013 4:47 PM, Andi Kleen wrote:
> >> Also, the changelogs don't appear to discuss one obvious downside: the
> >> latency incurred in bringing a bank out of one of the low-power states
> >> and back into full operation.  Please do discuss and quantify that to
> >> the best of your knowledge.
> >
> > On Sandy Bridge the memry wakeup overhead is really small. It's on by default
> > in most setups today.
> 
> btw note that those kind of memory power savings are content-preserving,
> so likely a whole chunk of these patches is not actually needed on SNB
> (or anything else Intel sells or sold)

(head spinning a bit).  Could you please expand on this rather a lot?

