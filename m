Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbaGHSmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:42:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:57033 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbaGHSma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:42:30 -0400
Date: Tue, 8 Jul 2014 15:42:25 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf trace: add pagefault statistics
Message-ID: <20140708184225.GC11917@kernel.org>
References: <1404842716-19190-1-git-send-email-stfomichev@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404842716-19190-1-git-send-email-stfomichev@yandex-team.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 08, 2014 at 10:05:16PM +0400, Stanislav Fomichev escreveu:
> 'perf trace' can show summary of events using -S option. This commit
> also reports number of major/minor pagefault events in this summary.
> 
> $ perf trace -s --pf all -- sleep 1

Thanks, applied.

- Arnaldo
