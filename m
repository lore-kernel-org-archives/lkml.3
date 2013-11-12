Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3KLOPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:15:31 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43147 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab3KLOP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:15:29 -0500
Message-ID: <52823800.3020608@gmail.com>
Date: Tue, 12 Nov 2013 07:15:28 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf trace: Fix syscall summary duration order
References: <1384265410-12344-1-git-send-email-penberg@kernel.org>
In-Reply-To: <1384265410-12344-1-git-send-email-penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13, 7:10 AM, Pekka Enberg wrote:
> Switch duration order to minimum, average, maximum for the '--summary'
> command line option because it's more natural to read.
>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>
> ---
>   tools/perf/builtin-trace.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

I would change the 'Fix' in the summary line to 'Change'. Other than that...

Acked-by: David Ahern <dsahern@gmail.com>

