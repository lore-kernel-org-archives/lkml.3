Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaK1R4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:56:16 -0500
Received: from one.firstfloor.org ([193.170.194.197]:51083 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaK1R4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:56:15 -0500
Date: Fri, 28 Nov 2014 18:56:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Milian Wolff <mail@milianw.de>
Subject: Re: [PATCH v2 2/2] perf record: Show precise number of samples
Message-ID: <20141128175613.GY12538@two.firstfloor.org>
References: <1417158708-31401-2-git-send-email-namhyung@kernel.org>
 <1417158859-31538-1-git-send-email-namhyung@kernel.org>
 <20141128124426.GE27703@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128124426.GE27703@krava.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Reported-by: Milian Wolff <mail@milianw.de>
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> 
> eeeey great, I mean.. finally ;-) 

Yes I like it too.

BTW it would be nice if we could show down a break down on how many
bytes the different options passed to perf record added, by accounting
the different header fields. That would guide people who suffer
from too large perf.data files.

-Andi
