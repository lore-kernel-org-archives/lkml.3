Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbaF0X23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:28:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39637 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbaF0X22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:28:28 -0400
Date: Sat, 28 Jun 2014 01:28:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tool: Carve out ctype.h et al
Message-ID: <20140627232819.GB21418@pd.tnic>
References: <1403688184-6917-1-git-send-email-bp@alien8.de>
 <20140625192547.GF1153@krava.brq.redhat.com>
 <20140625203836.GD13845@pd.tnic>
 <20140625211757.GD18773@kernel.org>
 <20140626073802.GC1177@krava.brq.redhat.com>
 <20140626103223.GB1284@pd.tnic>
 <20140626121433.GA2600@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140626121433.GA2600@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 02:14:33PM +0200, Jiri Olsa wrote:
> this one compiles ok for me

Ok, cool. So guys, can we apply this one so that I can continue with the
next round?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
