Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab3KMSGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:06:20 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53209 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab3KMSGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:06:12 -0500
Message-ID: <5283BF93.80603@gmail.com>
Date: Wed, 13 Nov 2013 11:06:11 -0700
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

On 11/13/13, 11:03 AM, Frederic Weisbecker wrote:
> I see. I can reproduce, I'll check and see what happens. It would be nice if
> we could have an option to dump internal perf events like comm events as well
> in the perf script stream.

I've been thinking about moving the event dumping code from perf-script 
to perf-dump. In the process could add an argument to dump events -- 
similar to -D option for report/script, but more inline with the output 
that perf-script shows now.

David
