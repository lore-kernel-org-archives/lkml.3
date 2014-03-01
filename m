Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaCABHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 20:07:40 -0500
Received: from one.firstfloor.org ([193.170.194.197]:36779 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaCABHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 20:07:39 -0500
Date: Sat, 1 Mar 2014 02:07:37 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        namhyung@kernel.org
Subject: Re: [PATCH 11/19] perf, c2c: Add in sort on physid
Message-ID: <20140301010737.GY22728@two.firstfloor.org>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-12-git-send-email-dzickus@redhat.com>
 <87ppm7aws9.fsf@tassilo.jf.intel.com>
 <20140228194422.GL25953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228194422.GL25953@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think I understand the problem enough to know what to fix.  I just
> copied this piece of code from builtin-report.c and things seemed to work.
> 
> Mind giving me some details and I can look at fixing it. :-)

sort.c even though has all these sort keys only sorts by period.
It should instead sort by all the specified keys in order instead.

Namhyung looked at it at some point.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
