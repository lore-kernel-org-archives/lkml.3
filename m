Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaFPGP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 02:15:28 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:57391 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660AbaFPGP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 02:15:26 -0400
X-Yandex-Uniq: ec873bbd-0e78-4f4b-b4d8-4166a7d387e8
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Mon, 16 Jun 2014 10:15:22 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Namhyung Kim <namhyung@kernel.org>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perf timechart: add more options to IO mode
Message-ID: <20140616061522.GB9394@stfomichev-desktop.yandex.net>
References: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
 <1402412694-5996-4-git-send-email-stfomichev@yandex-team.ru>
 <87lht39bx0.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lht39bx0.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's in nano-second unit, right?  If so, it's very unconvenient for user
> to specify.  Maybe we could support to parse unit (s, ms, us, ...) also.
Yes, it's nano-second. I didn't want to limit it to ms, because I
still want to be able to specify ns. I think it's a good idea to support
parsing units. Can I use OPT_CALLBACK or there is a better way to do that
(I couldn't find any similar conversions in perf)?
