Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaGIWTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:19:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbaGIWTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:19:48 -0400
Date: Thu, 10 Jul 2014 00:19:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/9] perf, tools: Add support for text descriptions of
 events and alias add
Message-ID: <20140709221923.GE20938@krava.redhat.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403910964-11017-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:15:57PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Change pmu.c to allow descriptions of events and add interfaces
> to add aliases at runtime from another file. To be used by jevents in the
> next patch.
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---

SNIP

> +}
> +
> +static int get_columns(void)
> +{
> +	/*
> +	 * Should ask the terminal with TIOCGWINSZ here, but we
> +	 * need the original fd before the pager.
> +	 */
> +	return 79;
>  }

so this ^^^ gets removed by
  perf, tools: Query terminal width and use in perf list

please move that patch ahead of this one

jirka
