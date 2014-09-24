Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaIXVto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:49:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:17014 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaIXVtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:49:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,591,1406617200"; 
   d="scan'208";a="578482865"
From: Andi Kleen <andi@firstfloor.org>
To: "Elliott\, Robert \(Server Storage\)" <Elliott@hp.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jens Axboe \<axboe\@kernel.dk\> \(axboe\@kernel.dk\)" 
	<axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: ftrace function-graph and interprocessor interrupts
References: <94D0CD8314A33A4D9D801C0FE68B402958C9BE4D@G9W0745.americas.hpqcorp.net>
Date: Wed, 24 Sep 2014 14:49:41 -0700
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C9BE4D@G9W0745.americas.hpqcorp.net>
	(Robert Elliott's message of "Wed, 24 Sep 2014 21:14:13 +0000")
Message-ID: <87mw9oelje.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Elliott, Robert (Server Storage)" <Elliott@hp.com> writes:

> The function-graph tracer marks some interrupt handler functions
> with ==========>  and <========== labels.

I'm not sure the marking is really that useful. Isn't it always obvious
from the function names where an interrupt starts/end?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
