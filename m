Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab3EVIjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:39:14 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:56860 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3EVIjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:39:10 -0400
Message-ID: <519C842B.60101@kernel.org>
Date: Wed, 22 May 2013 11:39:07 +0300
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
Subject: Re: [PATCH 3/5] perf gtk/hists: Display callchain overhead also
References: <1369211258-3163-1-git-send-email-namhyung@kernel.org> <1369211258-3163-4-git-send-email-namhyung@kernel.org>
In-Reply-To: <1369211258-3163-4-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 11:27 AM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> Add a new column for showing callchain overhead.  I feel like it's
> more natural than having those overhead next to a first child in a
> same column.
>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>

