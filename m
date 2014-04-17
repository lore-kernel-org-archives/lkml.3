Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161328AbaDQNi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:38:27 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53773 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaDQNi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:38:26 -0400
Subject: Re: [PATCH 0/3] perf top/tui: Fixes for percentage filter behavior
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20140417120046.GC7422@krava.brq.redhat.com>
References: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
	 <20140417120046.GC7422@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Apr 2014 22:38:19 +0900
Message-ID: <1397741900.1731.17.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

2014-04-17 (목), 14:00 +0200, Jiri Olsa:
> On Thu, Apr 17, 2014 at 04:53:23PM +0900, Namhyung Kim wrote:
> > Hi,
> > 
> > This is a small fixes for a bug in perf top I found during some tests.
> > It gets segfault if symbol filter found no entries - accessing NULL
> > pointer in that case.
> 
> yep, I hit that yesterday as well, but I ended up just with
> the patch below, your changes seems more comprehensive ;-)
> going to review..

Well, the end result will be same, but I think it should have 0
nr_entries when there's no entry to show.

Thanks,
Namhyung


