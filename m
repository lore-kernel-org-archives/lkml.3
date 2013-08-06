Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3HFF6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:58:18 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:44237 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3HFF6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:58:17 -0400
MIME-Version: 1.0
In-Reply-To: <1375766056-19377-5-git-send-email-namhyung@kernel.org>
References: <1375766056-19377-1-git-send-email-namhyung@kernel.org>
	<1375766056-19377-5-git-send-email-namhyung@kernel.org>
Date: Tue, 6 Aug 2013 08:58:16 +0300
X-Google-Sender-Auth: OEGutHTBItBlDi6weXlfRa48dUc
Message-ID: <CAOJsxLG20M53jJhSO5pOJaottEvnkqVJ63J6XtT8Kp_Sk69O=Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] perf tools: Run dynamic loaded GTK browser
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
> Run GTK hist and annotation browser using libdl.
>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
