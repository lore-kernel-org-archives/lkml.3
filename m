Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaF0InZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:43:25 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:50277 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbaF0InM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:43:12 -0400
X-Yandex-Uniq: 7dd882a4-4845-47d4-917a-d2040fa130a9
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Fri, 27 Jun 2014 12:43:07 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] perf trace: add pagefault statistics
Message-ID: <20140627084307.GF21788@stfomichev-desktop.yandex.net>
References: <1403799268-1367-1-git-send-email-stfomichev@yandex-team.ru>
 <1403799268-1367-5-git-send-email-stfomichev@yandex-team.ru>
 <20140626194115.GE18773@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626194115.GE18773@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Where is it?
>  usleep (19155), 151 events, 84.4%, 0:68 faults, 0.000 msec
                                      ^^^^^^^^^^^
				      maj:min
