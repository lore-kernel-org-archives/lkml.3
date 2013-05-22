Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3EVIlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:41:04 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:56170 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3EVIlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:41:00 -0400
Message-ID: <519C8499.2070404@kernel.org>
Date: Wed, 22 May 2013 11:40:57 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/5] perf report: Add support for callchains on GTK browser
References: <1369211258-3163-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1369211258-3163-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 11:27 AM, Namhyung Kim wrote:
> This patchset implements callchain support in GTK report browser as
> Pekka requested.  I put callchain overhead on its own column because
> it looks more natural to me.  Please take a look and give me comments.
>
> You can get it from 'perf/callchain-gtk-v1' branch on my tree at
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>
>
> Any comments are welcome, thanks!

Looks good to me! I'd prefer to see this go in before the more 
experimental hierarchy view changes.

			Pekka

