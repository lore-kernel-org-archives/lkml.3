Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbaGIWTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:19:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbaGIWTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:19:41 -0400
Date: Thu, 10 Jul 2014 00:19:13 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/9] perf, tools: Add support for reading JSON event
 files v3
Message-ID: <20140709221913.GD20938@krava.redhat.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403910964-11017-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:15:58PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>

SNIP

> +}
> diff --git a/tools/perf/util/jevents.h b/tools/perf/util/jevents.h
> new file mode 100644
> index 0000000..4c2b879
> --- /dev/null
> +++ b/tools/perf/util/jevents.h
> @@ -0,0 +1,3 @@

missing standard '#ifndef ...' macros

> +int json_events(const char *fn,
> +		int (*func)(void *data, char *name, char *event, char *desc),
> +		void *data);

jirka
