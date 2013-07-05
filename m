Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855Ab3GEPEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:04:16 -0400
Received: from mail-ye0-f178.google.com ([209.85.213.178]:51385 "EHLO
	mail-ye0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab3GEPEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:04:15 -0400
Date: Fri, 5 Jul 2013 12:04:08 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/6] perf report: Add support for callchains on GTK
 browser (v2)
Message-ID: <20130705150408.GE2559@ghostprotocols.net>
References: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 04, 2013 at 06:22:11PM +0900, Namhyung Kim escreveu:
> Hi,
> 
> This patchset implements callchain support in GTK report browser as
> Pekka requested.  Please take a look and give me comments.
> 
> v2 changes)
>  * fix a bug on percent calculation of children nodes
>  * show topmost symbol only when multiple paths exist for a node
>  * add alternating background colors (Ingo)
>  * put callchain info into existing overhead and symbol column (Arnaldo)

Thanks, applied.

- Arnaldo
