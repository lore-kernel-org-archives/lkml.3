Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3FDIU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:20:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52387 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab3FDIUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:20:55 -0400
Date: Tue, 4 Jun 2013 10:20:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 16/16] perf, persistent: Allow multiple users for an event
Message-ID: <20130604082042.GB23640@pd.tnic>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <1369990056-10310-17-git-send-email-rric@kernel.org>
 <20130603134925.GA13548@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130603134925.GA13548@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 03:49:25PM +0200, Jiri Olsa wrote:
> maybe check for valid cpu, since perf_get_persistent_event_fd is
> called directly from syscall allowing anything in cpu

That should be fine - we're traversing a per-cpu list of events there.

> (unrelated to this patch, but I couldn't find the original
> patch that adds perf_get_persistent_event_fd)

Try this:

http://git.kernel.org/cgit/linux/kernel/git/bp/bp.git/log/?h=persistent5.1

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
