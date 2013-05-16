Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3EPAtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 20:49:06 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:63338 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3EPAtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 20:49:01 -0400
X-AuditID: 9c93017e-b7cf8ae000004f65-a5-51942cfbe639
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [RFC/PATCH 2/2] perf report: Add --time-filter option
References: <1368609839-19899-1-git-send-email-namhyung@kernel.org>
	<1368609839-19899-2-git-send-email-namhyung@kernel.org>
	<CABPqkBSEGpa3wyxdfsBRey=4J_yQXP7QG_=+1rLy0vhD03vp4A@mail.gmail.com>
Date: Thu, 16 May 2013 09:48:58 +0900
In-Reply-To: <CABPqkBSEGpa3wyxdfsBRey=4J_yQXP7QG_=+1rLy0vhD03vp4A@mail.gmail.com>
	(Stephane Eranian's message of "Wed, 15 May 2013 13:51:20 +0200")
Message-ID: <871u97696t.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Wed, 15 May 2013 13:51:20 +0200, Stephane Eranian wrote:
> Hi,
>
> I think what could also be useful would be an option to consider only
> the samples when the rate as reported by the timestamp exceed a
> user provided rate per sec. That would eliminate samples which are
> coming from low activity periods.

Sounds good.  I'll try to play with it next time.

Thanks,
Namhyung
