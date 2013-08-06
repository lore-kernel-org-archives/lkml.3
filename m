Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3HFF5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:57:33 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60759 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab3HFF5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:57:32 -0400
MIME-Version: 1.0
In-Reply-To: <1375766056-19377-4-git-send-email-namhyung@kernel.org>
References: <1375766056-19377-1-git-send-email-namhyung@kernel.org>
	<1375766056-19377-4-git-send-email-namhyung@kernel.org>
Date: Tue, 6 Aug 2013 08:57:31 +0300
X-Google-Sender-Auth: zfOd3F50a_C6OkAY9Uyv3Lthnyc
Message-ID: <CAOJsxLELizANRKLvp1dL2UkMrnBAmZ5e+DCu-K=Oq5GJcbvYzQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] perf tools: Setup GTK browser dynamically
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
> Call setup/exit GTK browser function using libdl.
>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
