Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3EVIig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:38:36 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:63340 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3EVIid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:38:33 -0400
Message-ID: <519C8405.20009@kernel.org>
Date: Wed, 22 May 2013 11:38:29 +0300
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
Subject: Re: [PATCH 2/5] perf gtk/hists: Add support for callchains
References: <1369211258-3163-1-git-send-email-namhyung@kernel.org> <1369211258-3163-3-git-send-email-namhyung@kernel.org>
In-Reply-To: <1369211258-3163-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 11:27 AM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> Add a new column to display callchain information.  It's only enabled
> when recorded with -g and has symbol sort key.
>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>

