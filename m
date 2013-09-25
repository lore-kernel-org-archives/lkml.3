Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3IYXri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:47:38 -0400
Received: from one.firstfloor.org ([193.170.194.197]:48254 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3IYXrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:47:36 -0400
Date: Thu, 26 Sep 2013 01:47:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mgorman@suse.de,
        dave@sr71.net, hannes@cmpxchg.org, tony.luck@intel.com,
        matthew.garrett@nebula.com, riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl,
        gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [Results] [RFC PATCH v4 00/40] mm: Memory Power Management
Message-ID: <20130925234734.GK18242@two.firstfloor.org>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
 <52437128.7030402@linux.vnet.ibm.com>
 <20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, the changelogs don't appear to discuss one obvious downside: the
> latency incurred in bringing a bank out of one of the low-power states
> and back into full operation.  Please do discuss and quantify that to
> the best of your knowledge.

On Sandy Bridge the memry wakeup overhead is really small. It's on by default
in most setups today.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
