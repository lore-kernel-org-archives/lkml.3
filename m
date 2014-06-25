Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaFYULx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:11:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33941 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbaFYULv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:11:51 -0400
Date: Wed, 25 Jun 2014 22:11:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tool: Carve out ctype.h et al
Message-ID: <20140625201147.GB13845@pd.tnic>
References: <1403688184-6917-1-git-send-email-bp@alien8.de>
 <20140625192547.GF1153@krava.brq.redhat.com>
 <20140625194254.GC18773@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140625194254.GC18773@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 04:42:54PM -0300, Arnaldo Carvalho de Melo wrote:
> Probably will come in a separate patchkit that is dependent on this,
> but not strictly related?

Yeah, so roughly speaking, we want to carve out the code which opens and
handles events in perf tool so that we can use it in other tools. In the
particular example with the ras daemon, we want to be able to open a
tracepoint in userspace and read from it.

We're doing this piecewise because perf tool changes too fast and I've
done a full conversion patchset a couple of times already only to
realize that it grows obsolete practically only days after sending it
out. (Btw, for that it is all your fault, of course :-P). Which makes
preparing a full patchset almost impossible.

Does this explanation make sense?

@jirka: I'll try to reproduce your build error.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
