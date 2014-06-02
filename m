Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaFBPZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:25:10 -0400
Received: from one.firstfloor.org ([193.170.194.197]:51698 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaFBPZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:25:08 -0400
Date: Mon, 2 Jun 2014 17:25:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, Yan Zheng <zheng.z.yan@intel.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Joe Mario <jmario@redhat.com>,
        Richard Fowles <rfowles@redhat.com>, Don Zickus <dzickus@redhat.com>,
        liang.kan@intel.com
Subject: Re: [RFC/BUG] not working LLC-load-misses on SandyBridge (42) and
 Haswell
Message-ID: <20140602152506.GO25366@two.firstfloor.org>
References: <1400858147-7155-1-git-send-email-jolsa@kernel.org>
 <878upjg6lx.fsf@sejong.aot.lge.com>
 <20140601142622.GA9131@krava.brq.redhat.com>
 <20140602115550.GA1215@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602115550.GA1215@krava.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Joe asked about issues with LLC-load-misses on Haswell. I tried
> and found it non functional on SandyBridge (42) as well:

There are lots of issues with the event tables. They need a large
scale revamp.

I have some changes already, but they need more

-Andi
