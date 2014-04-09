Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbaDIB3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 21:29:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:65174 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235AbaDIB3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 21:29:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,822,1389772800"; 
   d="scan'208";a="517132404"
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, peterz@infradead.org,
        eranian@google.com, andi.kleen@intel.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 03/15 V3] perf c2c: Shared data analyser
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-4-git-send-email-dzickus@redhat.com>
	<87a9bwxq64.fsf@sejong.aot.lge.com> <20140408142226.GV8488@redhat.com>
	<87ioqjuxnn.fsf@sejong.aot.lge.com>
Date: Tue, 08 Apr 2014 18:29:42 -0700
In-Reply-To: <87ioqjuxnn.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Wed, 09 Apr 2014 09:58:04 +0900")
Message-ID: <87y4zfi92x.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@kernel.org> writes:
>
> Well, I'm not sure ;-)  Yes, the c2c is a complex tool which might
> deserve an own command, but the functionality is very similar and I
> guess there's something to share between them.

They work very differently.  I don't see a lot of potential
for sharing.

perf mem is basically just a way to annotate normal samples slightly
with addresses, while c2c is fundamentally address driven.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
