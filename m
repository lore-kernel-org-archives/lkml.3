Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3GIOVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:21:23 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55087 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3GIOVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:21:20 -0400
Message-ID: <51DC1C5E.3090808@gmail.com>
Date: Tue, 09 Jul 2013 08:21:18 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tools: Fixup for removing -f option in perf record
References: <1372307120-737-1-git-send-email-namhyung@kernel.org> <51DBBEA8.3010208@lge.com>
In-Reply-To: <51DBBEA8.3010208@lge.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/13 1:41 AM, Namhyung Kim wrote:
> Hi Arnaldo,
>
> You may want to merge this patch too. :)
>

He did. See 77d03596 and the note:

    [ combined patch removing the -f usage in various sub-commands, such 
as 'perf sched', etc, by Namhyung Kim ]

David

