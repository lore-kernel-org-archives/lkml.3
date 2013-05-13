Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab3EMI6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:58:48 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33569 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3EMI6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:58:46 -0400
MIME-Version: 1.0
In-Reply-To: <1368434503-29373-2-git-send-email-namhyung@kernel.org>
References: <1368434503-29373-1-git-send-email-namhyung@kernel.org>
	<1368434503-29373-2-git-send-email-namhyung@kernel.org>
Date: Mon, 13 May 2013 11:58:45 +0300
X-Google-Sender-Auth: XHqOngO67rik-pn5Ul0n5ka3ZGQ
Message-ID: <CAOJsxLG_ygNrTK7zOscarfKwDjSDiKwBijAEtkCZu3Baya+JZw@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf top: Add --percent-limit option
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 11:41 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> The --percent-limit option is for not showing small overheaded entries
> in the output.
>
> Cc: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
