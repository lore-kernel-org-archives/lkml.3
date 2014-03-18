Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbaCRQdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:33:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:4493 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbaCRQdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:33:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,678,1389772800"; 
   d="scan'208";a="502403359"
Message-ID: <5328753B.2050107@intel.com>
Date: Tue, 18 Mar 2014 09:32:59 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        lsf@lists.linux-foundation.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: [LSF/MM TOPIC] Testing Large-Memory Hardware
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a quick topic that could perhaps be addressed along with the
testing topic that Dave Jones proposed.  I won't be attending, but there
will be a couple of other Intel folks there.  This should be a fairly
quick thing to address.

Topic:

Fengguang Wu who runs the wonderful LKP and 0day build tests was
recently asking if I thought there was value in adding a large-memory
system, say with 1TB of RAM.  LKP is the system that generates these
kinds of automated bug reports and performance tests:

	http://lkml.org/lkml/2014/3/9/201

My gut reaction was that we'd probably be better served by putting
resources in to systems with higher core counts rather than lots of RAM.
 I have encountered the occasional boot bug on my 1TB system, but it's
far from a frequent occurrence, and even more infrequent to encounter
things at runtime.

Would folks agree with that?  What kinds of tests, benchmarks, stress
tests, etc... do folks run that are both valuable and can only be run on
a system with a large amount of actual RAM?
