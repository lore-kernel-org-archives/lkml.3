Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab3DBPJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:09:49 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:37068 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760270Ab3DBPJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:09:47 -0400
Message-ID: <515AF4B1.40309@gmail.com>
Date: Tue, 02 Apr 2013 09:09:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 01/23] perf: initial infrasructure for kconfig
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>  <1364874877-5618-2-git-send-email-dsahern@gmail.com> <1364890977.21627.86.camel@x61.thuisdomein>
In-Reply-To: <1364890977.21627.86.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/13 2:22 AM, Paul Bolle wrote:
>>   tools/perf/Makefile |    5 +++++
>>   1 file changed, 5 insertions(+)
>>   create mode 100644 tools/perf/Pconfig
>
> All current Kconfig files can be found with git ls-files "*Kconfig*".
> This file won't. Why does it need to be named differently?

It does not. I will rename to Kconfig.

David
