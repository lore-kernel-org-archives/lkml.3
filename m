Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaHVUT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:19:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:54533 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaHVUT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:19:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,383,1406617200"; 
   d="scan'208";a="588684128"
Date: Fri, 22 Aug 2014 13:19:04 -0700
From: Andi Kleen <ak@linux.intel.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] perf tools: parse the pmu event prefix and surfix
Message-ID: <20140822201904.GC5803@tassilo.jf.intel.com>
References: <1408736549-4630-1-git-send-email-kan.liang@intel.com>
 <1408736549-4630-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408736549-4630-2-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* The contents of the pmu_events should be in ascending sorted by symbol*/
> +static struct pmu_event_symbol pmu_events[] = {
> +	{ "abort", false},
> +	{ "capacity", false},
> +	{ "commit", false},
> +	{ "conflict", false},
> +	{ "el", true},
> +	{ "start", false},
> +	{ "tx", true},

This list should be read from sysfs, not hard coded.

-Andi
