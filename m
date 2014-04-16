Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaDPBLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 21:11:24 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35450 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaDPBLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 21:11:22 -0400
Date: Wed, 16 Apr 2014 10:11:20 +0900
From: Simon Horman <horms@verge.net.au>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-sh@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] sh: clk: Use cpufreq_for_each_valid_entry macro
 for iteration
Message-ID: <20140416011120.GC8833@verge.net.au>
References: <534DB238.5030201@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534DB238.5030201@semaphore.gr>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 01:27:04AM +0300, Stratos Karafotis wrote:
> The cpufreq core now supports the cpufreq_for_each_valid_entry macro
> helper for iteration over the cpufreq_frequency_table, so use it.
> 
> It should have no functional changes.
> 
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>

Thanks, I have queued this up.
