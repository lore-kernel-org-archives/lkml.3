Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761101Ab3DBIXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:23:02 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:60891 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269Ab3DBIXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:23:00 -0400
Message-ID: <1364890977.21627.86.camel@x61.thuisdomein>
Subject: Re: [PATCH 01/23] perf: initial infrasructure for kconfig
From: Paul Bolle <pebolle@tiscali.nl>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, linux-kbuild@vger.kernel.org
Date: Tue, 02 Apr 2013 10:22:57 +0200
In-Reply-To: <1364874877-5618-2-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
	 <1364874877-5618-2-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2013 08:22:58.0006 (UTC) FILETIME=[48418760:01CE2F7B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-01 at 21:54 -0600, David Ahern wrote:
> Add Pconfig file which will hold the build options.
> Update Makefile with new config files.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: linux-kbuild@vger.kernel.org
> ---
>  tools/perf/Makefile |    5 +++++
>  1 file changed, 5 insertions(+)
>  create mode 100644 tools/perf/Pconfig

All current Kconfig files can be found with git ls-files "*Kconfig*".
This file won't. Why does it need to be named differently?


Paul Bolle

