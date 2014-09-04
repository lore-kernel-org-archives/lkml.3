Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbaIDHsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:48:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52803 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaIDHso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:48:44 -0400
Date: Thu, 4 Sep 2014 09:48:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Theurer <atheurer@redhat.com>, linux-kernel@vger.kernel.org,
        oleg@redhat.com, umgwanakikbuti@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, srao@redhat.com, lwoodman@redhat.com,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/3] lockless sys_times and posix_cpu_clock_get
Message-ID: <20140904074836.GJ3190@worktop.ger.corp.intel.com>
References: <1408133138-22048-1-git-send-email-riel@redhat.com>
 <198309898.21797553.1408483311099.JavaMail.zimbra@redhat.com>
 <54076022.80202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54076022.80202@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Peter, Ingo, Andrew,
> 
> Do any of you have an objection to these patches?
> 
> Which tree should I merge them through?
> 
> I am happy to resubmit them against any tree, just let
> me know where you want the patches to go.

I suppose I can try and stuff them in -tip. I picked up this lot which
seems to still apply fine.

Thanks.
