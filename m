Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab3LUBAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 20:00:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43720 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3LUBAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 20:00:04 -0500
Message-ID: <52B4E815.8030304@gmail.com>
Date: Fri, 20 Dec 2013 18:00:05 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexis Berlemont <alexis.berlemont@gmail.com>,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf and Kconfig
References: <CAMesUR48C3zBo_UJByjC9GSqK6V=W_-WDQrsAoGye2yNADD3NQ@mail.gmail.com>
In-Reply-To: <CAMesUR48C3zBo_UJByjC9GSqK6V=W_-WDQrsAoGye2yNADD3NQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding perf maintainers]

On 12/20/13, 5:39 PM, Alexis Berlemont wrote:
> Hi,
>
> Here is a proposal of a small contribution which tries to fulfill the
> task "Use Kconfig to allow selecting features and build minimal
> version of perf,..." displayed on the todo page of the perf
> wiki (https://perf.wiki.kernel.org/index.php/Todo).
>
> I tried to continue the work started by David Ahern
> (https://github.com/dsahern/linux.git branch:perf-config). This
> version relies on the features detection tests available in
> linux/tools/perf/config/feature-checks so as to enable some
> configuration options (at least by default).
>
> This little task is not complete; more Kconfig options should be added
> for each perf tool (top, record, report, ...).
>
> I just wanted to ask whether you consider this proposal as interesting
> enough for inclusion and if you are ok with the way it is implemented.
>
> The code is available here: https://github.com/aberlemont/linux.git
> - branch: perf-config.

I know Jiri has an attempt in his tree and there have been a few 
discussions since then as well. I'll take a look at it next week. I 
would like to see it completed; I just don't have the time to do it.

David
