Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaB1Vyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:54:46 -0500
Received: from one.firstfloor.org ([193.170.194.197]:36311 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaB1Vyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:54:45 -0500
Date: Fri, 28 Feb 2014 22:54:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com
Subject: Re: [PATCH 00/19 V2] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
Message-ID: <20140228215442.GV22728@two.firstfloor.org>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <87wqgfawur.fsf@tassilo.jf.intel.com>
 <20140228194233.GK25953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228194233.GK25953@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's there. :-)
> 
> perf c2c -r -x, report
> 
> will spit out raw records in CSV format.

But most of the cooked data seems not? I saw
lots of printfs without separator support.

Sorry I meant data mining the cooked data,
e.g. plotting it.

-Andi
