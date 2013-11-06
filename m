Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3KFRsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:48:23 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:42170 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3KFRsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:48:21 -0500
Date: Wed, 6 Nov 2013 14:48:03 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf timechart improvements
Message-ID: <20131106174803.GA14062@ghostprotocols.net>
References: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
 <20131105172812.GA7329@ghostprotocols.net>
 <87li12x8aw.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li12x8aw.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 06, 2013 at 05:07:19PM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Tue, 5 Nov 2013 14:28:12 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Nov 01, 2013 at 08:25:44PM +0400, Stanislav Fomichev escreveu:
> >> This patch series adds more features to the perf timechart command:
> >> * -n option that adds possibility to limit number of tasks on SVG
> >> * -T option that adds possibility to show only tasks related info
> >> * -T and -P options now work with `perf timechart record` command to keep
> >>   perf.data small
> >> * -g option that adds possibility to record and add callchain to the SVG so
> >>   it's now possible to understand why some task went to sleep or what code
> >>   path woke it up
> >> * add titles to the SVG blocks so it's possible to see how long task is
> >>   running/sleeping/blocked
> >> 
> >> v2:
> >> * fix errors pointed out by Namhyung Kim <namhyung@kernel.org>
> >
> > Namhyung, are you ok now? Acked-by?
> 
> Not having time to review this yet.  I think I can do it tomorrow.

Ok, just asked because you provided comments on a previous patchkit
version.

- Arnaldo
