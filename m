Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964779AbaFIQyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:54:36 -0400
Received: from one.firstfloor.org ([193.170.194.197]:45639 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385AbaFIQyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:54:33 -0400
Date: Mon, 9 Jun 2014 18:54:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf record: Fix to honor user freq/interval properly
Message-ID: <20140609165431.GS25366@two.firstfloor.org>
References: <1402292617-26278-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402292617-26278-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 02:43:37PM +0900, Namhyung Kim wrote:
> When configuring event perf checked a wrong condition that user
> specified both of freq (-F) and period (-c) or the event has no
> default value.  This worked because most of events don't have default
> value and only tracepoint events have default of 1 (and it's not
> desirable to change it for those events).
> 
> However, Andi's downloadable event patch changes the situation so it
> cannot change the value for those events.  Fix it by allowing override
> the default value if user gives one of the options.

Thanks. Looks good. I'll drop my version.

-Andi
