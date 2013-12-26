Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3LZOSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:18:22 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:36130 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3LZOSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:18:20 -0500
Message-ID: <52BC3AA9.1020404@gmail.com>
Date: Thu, 26 Dec 2013 09:18:17 -0500
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Do not show stats if workload fails
References: <1387518748-25340-1-git-send-email-dsahern@gmail.com> <20131220075759.GA12937@gmail.com> <20131223193757.GA1396@ghostprotocols.net> <52B8D582.9090009@gmail.com> <20131224125342.GC17780@ghostprotocols.net> <20131224133003.GA23382@ghostprotocols.net> <52BC390A.2000504@gmail.com> <20131226141507.GD30980@ghostprotocols.net>
In-Reply-To: <20131226141507.GD30980@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/13, 9:15 AM, Arnaldo Carvalho de Melo wrote:
> Right, but I can't apply that patch, as it makes 'perf stat
> whatever-workload' to fail, as I realized when doing a demo to someone
> interested in using perf ;-\
>
> So for now I'm not applying that one.

right, so you want one with < 0 check or wait for something else? I was 
not expecting to find it in your perf/core branch, yet there it is.

>
> Ah, at this point elves are everywhere, dammit! ;-)

An elf put it there?

David

