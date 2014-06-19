Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbaFSMSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:18:10 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:54561 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758037AbaFSMSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:18:09 -0400
X-Yandex-Uniq: f2218227-b348-45c9-b2c3-2c842100aa91
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Thu, 19 Jun 2014 16:18:09 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Namhyung Kim <namhyung@kernel.org>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf timechart: implement IO mode
Message-ID: <20140619121809.GG15620@stfomichev-desktop.yandex.net>
References: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
 <1402412694-5996-2-git-send-email-stfomichev@yandex-team.ru>
 <87ppif9c3y.fsf@sejong.aot.lge.com>
 <20140616060804.GA9394@stfomichev-desktop.yandex.net>
 <87sin383cw.fsf@sejong.aot.lge.com>
 <20140618090034.GC15620@stfomichev-desktop.yandex.net>
 <87fvj191w4.fsf@sejong.aot.lge.com>
 <20140619095848.GE15620@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619095848.GE15620@stfomichev-desktop.yandex.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hmm.. it looks like an unrelated issue.  I can see the bars in inkscape,
> > but still see empty grey bars in firefox.
> I'll try to have a look; maybe I'm writing some non-standard svg
> instructions which fail on (probably) standard-compliant firefox and
> work on more robust inkscape.

Found it: if I specify space before number in quotes, like in:
<rect ... height=" 3.1" ...>

Firefox doesn't want to render it, but if I remove the space before the
number (3.1), it works just fine.
I'll fix it and will resend the series with fixes.
