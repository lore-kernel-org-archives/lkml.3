Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3KGPZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:25:35 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54971 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3KGPZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:25:33 -0500
Subject: Re: [PATCH v2 0/7] perf timechart improvements
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20131106174803.GA14062@ghostprotocols.net>
References: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
	 <20131105172812.GA7329@ghostprotocols.net>
	 <87li12x8aw.fsf@sejong.aot.lge.com>
	 <20131106174803.GA14062@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Nov 2013 00:25:27 +0900
Message-ID: <1383837927.1731.1.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Stanislav,

2013-11-06 (수), 14:48 -0300, Arnaldo Carvalho de Melo:
> Em Wed, Nov 06, 2013 at 05:07:19PM +0900, Namhyung Kim escreveu:
> > Hi Arnaldo,
> > 
> > On Tue, 5 Nov 2013 14:28:12 -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Fri, Nov 01, 2013 at 08:25:44PM +0400, Stanislav Fomichev escreveu:
> > >> This patch series adds more features to the perf timechart command:
> > >> * -n option that adds possibility to limit number of tasks on SVG
> > >> * -T option that adds possibility to show only tasks related info
> > >> * -T and -P options now work with `perf timechart record` command to keep
> > >>   perf.data small
> > >> * -g option that adds possibility to record and add callchain to the SVG so
> > >>   it's now possible to understand why some task went to sleep or what code
> > >>   path woke it up
> > >> * add titles to the SVG blocks so it's possible to see how long task is
> > >>   running/sleeping/blocked
> > >> 
> > >> v2:
> > >> * fix errors pointed out by Namhyung Kim <namhyung@kernel.org>
> > >
> > > Namhyung, are you ok now? Acked-by?
> > 
> > Not having time to review this yet.  I think I can do it tomorrow.
> 
> Ok, just asked because you provided comments on a previous patchkit
> version.

It seems to address all of my previous concerns, so

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung




