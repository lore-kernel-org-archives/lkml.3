Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaEONRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:17:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaEONRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:17:46 -0400
Date: Thu, 15 May 2014 15:17:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 11/20] perf report: Add -F option to specify output fields
Message-ID: <20140515131717.GF25858@krava.brq.redhat.com>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
 <1399876133-17963-12-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399876133-17963-12-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 03:28:44PM +0900, Namhyung Kim wrote:

SNIP

> +
> +int setup_output_field(void)
> +{
> +	char *tmp, *tok, *str;
> +	int ret = 0;
> +
> +	if (field_order == NULL)
> +		goto out;
> +
> +	reset_dimensions();

Do we want to call this in setup_sorting as well? In case
we mix the order of setup_output_field and setup_sorting
in the future?

jirka
