Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaEONCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:02:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaEONCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:02:05 -0400
Date: Thu, 15 May 2014 15:01:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/20] perf tools: Consolidate management of default sort
 orders
Message-ID: <20140515130137.GD25858@krava.brq.redhat.com>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
 <1399876133-17963-10-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399876133-17963-10-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 03:28:42PM +0900, Namhyung Kim wrote:

SNIP

>  
> +static const char *get_default_sort_order(void)
> +{
> +	const char *default_sort_orders[] = {
> +		default_sort_order,
> +		default_branch_sort_order,
> +		default_mem_sort_order,
> +		default_top_sort_order,
> +	};
> +
> +	BUG_ON(sort__mode > ARRAY_SIZE(default_sort_orders));

it should be >= in here ^^^

jirka
