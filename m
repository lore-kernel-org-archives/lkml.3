Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3HFF5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:57:03 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48439 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab3HFF5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:57:00 -0400
MIME-Version: 1.0
In-Reply-To: <1375766056-19377-3-git-send-email-namhyung@kernel.org>
References: <1375766056-19377-1-git-send-email-namhyung@kernel.org>
	<1375766056-19377-3-git-send-email-namhyung@kernel.org>
Date: Tue, 6 Aug 2013 08:56:58 +0300
X-Google-Sender-Auth: Kx1WnT5wVM7qPxYo3wfHpy9sYJA
Message-ID: <CAOJsxLHvBw4vL+Dyv8RmH18sQ93pP_G1AN0TDhRvWMwqqtGkqg@mail.gmail.com>
Subject: Re: [PATCH 2/4] perf tools: Separate out GTK codes to libperf-gtk.so
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 8:14 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Separate out GTK codes to a shared object called libperf-gtk.so.  This
> time only GTK codes are built with -fPIC and libperf remains as is.
>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
