Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaFXJKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 05:10:35 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:56567 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbaFXJKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:10:32 -0400
X-Yandex-Uniq: acb248e4-8119-45fd-bf68-6811aa8345f2
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 24 Jun 2014 13:10:22 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com,
        rusty@rustcorp.com.au, bp@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] perf timechart io mode
Message-ID: <20140624091022.GE20225@stfomichev-desktop.yandex.net>
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru>
 <20140624084113.GC31390@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624084113.GC31390@krava.redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hum, got this when trying:
> 
> [jolsa@krava perf]$ sudo ./perf timechart record -I
> ^C[ perf record: Woken up 2 times to write data ]
> [ perf record: Captured and wrote 1.071 MB perf.data (~46806 samples) ]
> [jolsa@krava perf]$ ./perf timechart
> Invalid previous event (non-zero)!
> 0x113f80 [0x8]: failed to process type: 68
Hm, I added a bunch of consistency checks which I couldn't actually hit
myself. Nice work :-) Can I get you perf.data?
