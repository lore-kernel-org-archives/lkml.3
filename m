Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141Ab3EMI6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:58:25 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:40993 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3EMI6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:58:24 -0400
MIME-Version: 1.0
In-Reply-To: <1368434503-29373-1-git-send-email-namhyung@kernel.org>
References: <1368434503-29373-1-git-send-email-namhyung@kernel.org>
Date: Mon, 13 May 2013 11:58:22 +0300
X-Google-Sender-Auth: ce34L1AT4Cr3B2YcooUgxlwQgSw
Message-ID: <CAOJsxLGNBJBrB-zL5CJwVStFT=s0L919yjvSFga7j_NakLHLeA@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf report: Add --percent-limit option
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
> in the output.  Maybe we want to set a certain default value like 0.1.
>
> Cc: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
