Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaFSJ6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:58:55 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:47989 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbaFSJ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:58:53 -0400
X-Yandex-Uniq: e11e4595-6a91-4faf-b23b-ef3b97325e3b
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Thu, 19 Jun 2014 13:58:48 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Namhyung Kim <namhyung@kernel.org>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf timechart: implement IO mode
Message-ID: <20140619095848.GE15620@stfomichev-desktop.yandex.net>
References: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
 <1402412694-5996-2-git-send-email-stfomichev@yandex-team.ru>
 <87ppif9c3y.fsf@sejong.aot.lge.com>
 <20140616060804.GA9394@stfomichev-desktop.yandex.net>
 <87sin383cw.fsf@sejong.aot.lge.com>
 <20140618090034.GC15620@stfomichev-desktop.yandex.net>
 <87fvj191w4.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvj191w4.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm.. it looks like an unrelated issue.  I can see the bars in inkscape,
> but still see empty grey bars in firefox.
I'll try to have a look; maybe I'm writing some non-standard svg
instructions which fail on (probably) standard-compliant firefox and
work on more robust inkscape.
