Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964963AbaCSNAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:00:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933739AbaCSNAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:00:52 -0400
Date: Wed, 19 Mar 2014 14:00:35 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com
Subject: Re: [PATCH 15/19] perf, c2c: Add callchain support
Message-ID: <20140319130035.GC7423@krava.brq.redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-16-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393609388-40489-16-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 12:43:04PM -0500, Don Zickus wrote:

SNIP

>  
> +static int
> +opt_callchain_cb(const struct option *opt, const char *arg, int unset)
> +{
> +	struct perf_c2c *c2c = (struct perf_c2c *)opt->value;
> +	char *tok, *tok2;
> +	char *endptr;


this still needs to be shared with report code, but
I'm guessing V2 was about moving to hist_entry-ies

jirka
