Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307AbaGXHro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:47:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54254 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934178AbaGXHrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:47:43 -0400
Date: Thu, 24 Jul 2014 00:46:46 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: andi@firstfloor.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] powerpc/perf: Implement get_cpu_str()
Message-ID: <20140724074645.GA18829@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072407-0320-0000-0000-00000011B849
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These two patches implement get_cpu_str() for powerpc.

get_cpu_str() will allow users to cache their perf event JSON files
and skip having to specify the --events-file with each perf invocation.

These patches are based on the commit

	commit 4a5e890
	Author: Andi Kleen <ak@linux.intel.com>
	Date:   Fri Jun 13 15:14:14 2014 -0700

	    perf, tools: Add a --no-desc flag to perf list

in Andi Kleen's tree

	git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc

At this point, I am mostly looking for feedback on the changes around
cache_cpu_str() and the get_cpu_str().

