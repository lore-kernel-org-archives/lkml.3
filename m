Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaLaL0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 06:26:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbaLaL0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 06:26:30 -0500
Date: Wed, 31 Dec 2014 12:26:03 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 04/37] perf tools: Add multi file interface to
 perf_data_file
Message-ID: <20141231112603.GB1256@krava.brq.redhat.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419405333-27952-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 04:15:00PM +0900, Namhyung Kim wrote:

SNIP

> +
>  static int open_file_read(struct perf_data_file *file)
>  {
>  	struct stat st;
> +	char path[PATH_MAX];
>  	int fd;
>  	char sbuf[STRERR_BUFSIZE];
>  
> -	fd = open(file->path, O_RDONLY);
> +	strcpy(path, file->path);

strncpy ?

jirka
