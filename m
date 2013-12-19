Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3LSMXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:23:42 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59893 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3LSL6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:39 -0500
Date: Thu, 19 Dec 2013 12:58:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Chunwei Chen <tuxoko@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] perf config: ignore generated files in feature-checks
Message-ID: <20131219115833.GA11279@gmail.com>
References: <1387441761-2153-1-git-send-email-tuxoko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387441761-2153-1-git-send-email-tuxoko@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chunwei Chen <tuxoko@gmail.com> wrote:

> Signed-off-by: Chunwei Chen <tuxoko@gmail.com>
> ---
>  tools/perf/config/feature-checks/.gitignore |    2 ++
>  1 file changed, 2 insertions(+)
>  create mode 100644 tools/perf/config/feature-checks/.gitignore
> 
> diff --git a/tools/perf/config/feature-checks/.gitignore b/tools/perf/config/feature-checks/.gitignore
> new file mode 100644
> index 0000000..9662c68
> --- /dev/null
> +++ b/tools/perf/config/feature-checks/.gitignore
> @@ -0,0 +1,2 @@
> +test-all
> +*.d

Why? These are cleaned out on 'make clean'.

Thanks,

	Ingo
