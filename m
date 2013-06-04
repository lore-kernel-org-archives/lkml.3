Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab3FDJel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:34:41 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50072 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3FDJek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:34:40 -0400
MIME-Version: 1.0
In-Reply-To: <1370337737-30812-3-git-send-email-namhyung@kernel.org>
References: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
	<1370337737-30812-3-git-send-email-namhyung@kernel.org>
Date: Tue, 4 Jun 2013 12:34:38 +0300
X-Google-Sender-Auth: A1SPgkyIkiLy8p7UbVRn4wDLrn8
Message-ID: <CAOJsxLHru=Ahw2iKMK=Sb=NJ_Yo2892HkSV-yBHk24sNuHjo=A@mail.gmail.com>
Subject: Re: [PATCH 2/6] perf gtk/hists: Add support for callchains
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 12:22 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> Display callchain information in the symbol column.  It's only enabled
> when recorded with -g and has symbol sort key.
>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
