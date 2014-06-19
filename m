Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaFSMiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:38:17 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54795 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbaFSMiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:38:15 -0400
Subject: Re: [PATCH 1/3] perf timechart: implement IO mode
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140619121809.GG15620@stfomichev-desktop.yandex.net>
References: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
	 <1402412694-5996-2-git-send-email-stfomichev@yandex-team.ru>
	 <87ppif9c3y.fsf@sejong.aot.lge.com>
	 <20140616060804.GA9394@stfomichev-desktop.yandex.net>
	 <87sin383cw.fsf@sejong.aot.lge.com>
	 <20140618090034.GC15620@stfomichev-desktop.yandex.net>
	 <87fvj191w4.fsf@sejong.aot.lge.com>
	 <20140619095848.GE15620@stfomichev-desktop.yandex.net>
	 <20140619121809.GG15620@stfomichev-desktop.yandex.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jun 2014 21:38:09 +0900
Message-ID: <1403181489.1670.20.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislav,

2014-06-19 (목), 16:18 +0400, Stanislav Fomichev:
> > > Hmm.. it looks like an unrelated issue.  I can see the bars in inkscape,
> > > but still see empty grey bars in firefox.
> > I'll try to have a look; maybe I'm writing some non-standard svg
> > instructions which fail on (probably) standard-compliant firefox and
> > work on more robust inkscape.
> 
> Found it: if I specify space before number in quotes, like in:
> <rect ... height=" 3.1" ...>
> 
> Firefox doesn't want to render it, but if I remove the space before the
> number (3.1), it works just fine.
> I'll fix it and will resend the series with fixes.

Nice!  I'll try to look at v3 tomorrow. :)

Thanks,
Namhyung


