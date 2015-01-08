Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbbAHGUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 01:20:37 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55286 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbbAHGUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 01:20:36 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 8 Jan 2015 15:18:35 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/30] perf tools: Add new build framework support
Message-ID: <20150108061835.GD7268@sejong>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
 <1420212972-21595-2-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420212972-21595-2-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 04:35:43PM +0100, Jiri Olsa wrote:
> Adding new build framework. There's no change for actual
> building at this point, it comes in the next patches.
> 
> The idea and more details are explained in the
> 'Documentation/Build' file.


[SNIP]
> diff --git a/tools/perf/Documentation/Build b/tools/perf/Documentation/Build
> new file mode 100644
> index 000000000000..7008520600eb
> --- /dev/null
> +++ b/tools/perf/Documentation/Build
> @@ -0,0 +1,123 @@
> +
> +1) perf build
> +=============
> +The perf build process consists of several separated building blocks,
> +which are linked together to form the perf binary:
> +  - libperf library (static)
> +  - perf builtin commands
> +  - traceevent library (static)
> +  - GTK ui library

And libapikfs library (static) ?

Thanks,
Namhyung
