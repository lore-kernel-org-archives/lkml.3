Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3LQPDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:03:23 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53546 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3LQPDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:03:22 -0500
Message-ID: <52B067AD.2050907@gmail.com>
Date: Tue, 17 Dec 2013 08:03:09 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
CC: Stanislav Fomichev <stfomichev@yandex-team.ru>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, namhyung@kernel.org, artagnon@gmail.com,
        jolsa@redhat.com
Subject: Re: [PATCH 5/5 v2] perf timechart: add emphasize option
References: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru> <20131216193800.GA19283@ghostprotocols.net> <20131217093855.GA3345@stfomichev-desktop> <20131217112303.GB27791@gmail.com> <20131217121522.GA6357@stfomichev-desktop> <20131217133821.GA6517@ghostprotocols.net> <20131217134137.GA29396@gmail.com> <20131217135923.GB6517@ghostprotocols.net> <20131217140608.GA29975@gmail.com> <20131217141532.GC6517@ghostprotocols.net>
In-Reply-To: <20131217141532.GC6517@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/13, 7:15 AM, Arnaldo Carvalho de Melo wrote:
> Just tried it here, and on fedora 18 one doesn't even needs the
> --color=always,

Default aliases:

$ alias
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

