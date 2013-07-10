Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3GJGL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:11:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab3GJGLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:11:55 -0400
From: Thomas Renninger <trenn@suse.de>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [RFC 0/4] perf tools: Remove event types data
Date: Wed, 10 Jul 2013 08:11:48 +0200
Message-ID: <1500509.qlU7PPnHQq@hammer82.arch.suse.de>
User-Agent: KMail/4.8.5 (Linux/3.4.47-2.38-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
References: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 09, 2013 06:48:55 PM Jiri Olsa wrote:
> hi,
> following up on the 'perf timechart' FIXME note and changing
> its tracepoint match not to use event types data.

Looks sane and pretty straight forward.
Still I am not that deep involved in perf to give a Reviewed-by: quickly...

#define SUPPORT_OLD_POWER_EVENTS
could also vanish, maybe with the next round.

         Thomas
