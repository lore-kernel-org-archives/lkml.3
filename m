Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3KVPUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:20:41 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43715 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab3KVPUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:20:36 -0500
Message-ID: <528F7641.2010003@gmail.com>
Date: Fri, 22 Nov 2013 08:20:33 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
References: <20131121100722.GA25459@pd.tnic> <20131121111744.GA27513@gmail.com> <20131121113014.GA26009@pd.tnic> <20131121114224.GA27704@gmail.com> <20131121120605.GC26009@pd.tnic> <20131121150524.GA24806@ghostprotocols.net> <20131121152804.GI26009@pd.tnic> <20131121173714.GD24806@ghostprotocols.net> <20131122122701.GA1480@gmail.com> <20131122135034.GA20146@nazgul.tnic> <20131122150055.GC11305@ghostprotocols.net>
In-Reply-To: <20131122150055.GC11305@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/13, 8:00 AM, Arnaldo Carvalho de Melo wrote:
>
> Lets do one at a time, so far we agreed that the ones that involves
> parsing procfs/sysfs etc should go in tools/lib/(fs)?kapi, so lets do
> that one.

libsysfs & libsysfs-devel?

