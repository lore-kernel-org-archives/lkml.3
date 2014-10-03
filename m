Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaJCMzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:55:18 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55561 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaJCMzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:55:15 -0400
Message-ID: <542E9CAC.3080108@hitachi.com>
Date: Fri, 03 Oct 2014 21:55:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 3/5] perf/sdt: Show SDT cache contents
References: <20141001023723.28985.39736.stgit@hemant-fedora> <20141001024815.28985.8980.stgit@hemant-fedora>
In-Reply-To: <20141001024815.28985.8980.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/01 11:48), Hemant Kumar wrote:
> @@ -35,10 +45,13 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
>  		OPT_CALLBACK('a', "add", NULL, "filename",
>  			     "add SDT events from a file.",
>  			     opt_add_sdt_events),
> +		OPT_CALLBACK_NOOPT('s', "dump", NULL, "show SDT events",
> +				   "Read SDT events from cache and display.",
> +				   opt_show_sdt_events),

Just one note here. -s and --dump are a bit odd. how about using -D for short ops?

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


