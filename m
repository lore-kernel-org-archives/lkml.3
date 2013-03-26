Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792Ab3CZOk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:40:29 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:51250 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933438Ab3CZOk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:40:28 -0400
Date: Tue, 26 Mar 2013 15:40:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf sort: Add 'addr' sort key
Message-ID: <20130326144023.GA1621@gmail.com>
References: <1364299918-31175-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364299918-31175-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> New addr sort key provides a way to sort the entries by the symbol
> addresses.

No objections from me - just wondering about the motivation: why would we 
want to sort by symbol address?

Perhaps to see the overhead layout/distribution within a DSO, to better 
cache-pack hot functions by placing them next to each other?

Putting a short usecase into the changelog (or even better, the 
documentation) would be nice.

Thanks,

	Ingo
