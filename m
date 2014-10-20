Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaJTHzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:55:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbaJTHzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:55:12 -0400
Date: Mon, 20 Oct 2014 09:54:54 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/8] perf, tools: Add --branch-history option to report
Message-ID: <20141020075454.GB10629@krava.redhat.com>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411774636-6870-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:37:10PM -0700, Andi Kleen wrote:

SNIP

> +		  const char *str __maybe_unused, int unset)
> +{
> +	int *branch_mode = opt->value;
> +
> +	*branch_mode = !unset;
> +	return 0;
> +}
> +
> +static int
>  parse_percent_limit(const struct option *opt, const char *str,
>  		    int unset __maybe_unused)
>  {
> @@ -564,7 +575,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>  	struct perf_session *session;
>  	struct stat st;
>  	bool has_br_stack = false;
> -	int branch_mode = -1;
> +	int branch_mode = -1, branch_call_mode = -1;

this one no longer applies as well

jirka
