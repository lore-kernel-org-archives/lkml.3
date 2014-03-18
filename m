Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaCRJ15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:27:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40659 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaCRJ1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:27:41 -0400
X-IronPort-AV: E=Sophos;i="4.97,676,1389715200"; 
   d="scan'208";a="9717994"
Message-ID: <53281119.2080201@cn.fujitsu.com>
Date: Tue, 18 Mar 2014 17:25:45 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Correct the message in feature-dwarf Checking
References: <1395133936-16580-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1395133936-16580-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/18 17:24:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/18 17:24:44,
	Serialize complete at 2014/03/18 17:24:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,
     Sorry for the noise, please ignore this patch.

On 03/18/2014 05:12 PM, Dongsheng Yang wrote:
> The package required for dwarf is named libdwarf-devel, rather
> than elfutils-devel.
>
> This patch corrects the package name in warning message in
> feature-dwarf checking.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>   tools/perf/config/Makefile | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index c234182..6b52134 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -285,11 +285,11 @@ else
>       ifndef NO_LIBDW_DWARF_UNWIND
>         ifneq ($(feature-libdw-dwarf-unwind),1)
>           NO_LIBDW_DWARF_UNWIND := 1
> -        msg := $(warning No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR);
> +        msg := $(warning No libdw DWARF unwind found, Please install libdwarf-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR);
>         endif
>       endif
>       ifneq ($(feature-dwarf), 1)
> -      msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
> +      msg := $(warning No libdw.h found or old libdw.h found or libdwarf-devel is older than 0.138, disables dwarf support. Please install new libdwarf-devel/libdw-dev);
>         NO_DWARF := 1
>       endif # Dwarf support
>     endif # libelf support

