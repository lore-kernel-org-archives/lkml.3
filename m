Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3LBREx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:04:53 -0500
Received: from one.firstfloor.org ([193.170.194.197]:44858 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3LBREu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:04:50 -0500
Date: Mon, 2 Dec 2013 18:04:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC 0/3] perf tools: Show time info (v1)
Message-ID: <20131202170448.GF17656@two.firstfloor.org>
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 03:53:16PM +0900, Namhyung Kim wrote:
> Hi,
> 
> Sometimes users might want to see time information along with the
> performance result but the perf cannot provide it currently.
> 
> In this patchset, I added such feature using sample->time.  When the
> perf processes sample events, it calculate time info and update last
> timestamp.  It keeps the last timestamp for each evsel (and for each
> cpu if it's a per-cpu session).

Does the sorting on arbitary fields work now?

I believe to make use of this you totally want to sort on it too,
but traditionally perf report could only sort on a single field.

Without sorting adding more and more fields is just confusing. 

-Andi
