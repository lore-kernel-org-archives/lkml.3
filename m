Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab3FDJfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:35:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39618 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3FDJfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:35:48 -0400
MIME-Version: 1.0
In-Reply-To: <1370337737-30812-7-git-send-email-namhyung@kernel.org>
References: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
	<1370337737-30812-7-git-send-email-namhyung@kernel.org>
Date: Tue, 4 Jun 2013 12:35:47 +0300
X-Google-Sender-Auth: dj5-sBMnJnzkK-356D2e77nFrQo
Message-ID: <CAOJsxLFUDX_Qew-dmFxiC8sMKpVjGqYK6J_XeKMjbix+1K6Wog@mail.gmail.com>
Subject: Re: [PATCH 6/6] perf gtk/hists: Set rules hint for the hist browser
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
> The 'rules' means that every second line of the tree view has a shaded
> background, which makes it easier to see which cell belongs to which
> row in the tree view.  It can be useful for a tree view that has a lot
> of rows.
>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
