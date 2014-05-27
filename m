Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaE0BGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:06:51 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50473 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaE0BGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:06:50 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 09/14] perf tools: Add dso__data_* interface descriptons
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
	<1400174615-2121-10-git-send-email-jolsa@kernel.org>
Date: Tue, 27 May 2014 10:06:48 +0900
In-Reply-To: <1400174615-2121-10-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Thu, 15 May 2014 19:23:30 +0200")
Message-ID: <87ppj0hvx3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 19:23:30 +0200, Jiri Olsa wrote:

[SNIP]
> +/**
> + * dso__data_read_addr - Read data from dso address
> + * @dso: dso object
> + * @machine: machine object
> + * @offset: file offset

s/offset/addr/

Thanks
Namhyung


> + * @data: buffer to store data
> + * @size: size of the @data buffer
> + *
> + * Read data from dso address.
> + */
>  ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
>  			    struct machine *machine, u64 addr,
>  			    u8 *data, ssize_t size)
