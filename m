Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3EVIjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:39:51 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:57792 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab3EVIjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:39:48 -0400
Message-ID: <519C8451.3080401@kernel.org>
Date: Wed, 22 May 2013 11:39:45 +0300
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
Subject: Re: [PATCH v2 5/5] perf gtk/hists: Make column headers resizable
References: <1369211258-3163-6-git-send-email-namhyung@kernel.org> <1369211832-3642-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1369211832-3642-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 11:37 AM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> Sometimes it's annoying to see when some symbols have very wierd long
> names.  So it might be a good idea to make column size changable.
>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
