Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3J2JfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:35:17 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:59489 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531Ab3J2JfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:35:15 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 29 Oct 2013 13:35:07 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Namhyung Kim <namhyung@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] perf timechart: group figures and add title with
 details
Message-ID: <20131029093507.GD3406@stfomichev-desktop>
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
 <1382439412-23713-5-git-send-email-stfomichev@yandex-team.ru>
 <87li1c5w81.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li1c5w81.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For consistency, wouldn't it be better renaming svg_sample() to
> svg_running()?
Makes sense. I'll resend the whole series with updates later.
