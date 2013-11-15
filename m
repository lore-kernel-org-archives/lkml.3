Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab3KOQaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:30:04 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64138 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3KOQ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:29:58 -0500
Message-ID: <52864BFF.20601@gmail.com>
Date: Fri, 15 Nov 2013 09:29:51 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf tip: fails to convert comm
References: <528306F5.8050307@gmail.com> <20131113180344.GA28039@localhost.localdomain>
In-Reply-To: <20131113180344.GA28039@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Frederic:

On 11/13/13, 11:03 AM, Frederic Weisbecker wrote:
>
> I see. I can reproduce, I'll check and see what happens. It would be nice if
> we could have an option to dump internal perf events like comm events as well
> in the perf script stream.

Any progress on a solution? This is a regression in 3.13.

David
