Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaGGV1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 17:27:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55515 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbaGGV1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 17:27:34 -0400
Date: Mon, 7 Jul 2014 23:27:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tool: Carve out ctype.h et al
Message-ID: <20140707212730.GD4776@pd.tnic>
References: <1403688184-6917-1-git-send-email-bp@alien8.de>
 <20140625192547.GF1153@krava.brq.redhat.com>
 <20140625203836.GD13845@pd.tnic>
 <20140625211757.GD18773@kernel.org>
 <20140626073802.GC1177@krava.brq.redhat.com>
 <20140626103223.GB1284@pd.tnic>
 <20140626121433.GA2600@krava.brq.redhat.com>
 <20140627232819.GB21418@pd.tnic>
 <20140707204752.GA11917@kernel.org>
 <20140707210739.GD20752@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140707210739.GD20752@krava.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 11:07:41PM +0200, Jiri Olsa wrote:
> yea, I meant it compiled for me ;-) I haven't reviewd the patch much,
> one thing I remember is that it should be separated into smaller changes..

This is because I created tools/lib/util/util.[ch] for the stuff which
ctype.* needs. I guess I can split it even further if that is easier
for you guys but I don't think the patch is too big to be unparseable -
it is basically moving code to tools/lib/, adding its own Makefile and
making the rest build again... well, almost. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
