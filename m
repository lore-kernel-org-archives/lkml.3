Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702Ab3GDIji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:39:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48128 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933599Ab3GDIjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:39:36 -0400
X-AuditID: 9c930179-b7b7fae000002142-89-51d534c6f8ae
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/6] perf report: Add support for callchains on GTK browser (v2)
References: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
Date: Thu, 04 Jul 2013 17:39:34 +0900
In-Reply-To: <1370337737-30812-1-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Tue, 4 Jun 2013 18:22:11 +0900")
Message-ID: <87d2qyzpkp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping!

On Tue,  4 Jun 2013 18:22:11 +0900, Namhyung Kim wrote:
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
>
> You can get it from 'perf/callchain-gtk-v2' branch on my tree at
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>
>
> Any comments are welcome, thanks!
> Namhyung
>
> Namhyung Kim (6):
>   perf gtk/hists: Use GtkTreeStore instead of GtkListStore
>   perf gtk/hists: Add support for callchains
>   perf gtk/hists: Display callchain overhead also
>   perf gtk/hists: Make column headers resizable
>   perf gtk/hists: Add a double-click handler for callchains
>   perf gtk/hists: Set rules hint for the hist browser
>
>  tools/perf/ui/gtk/hists.c | 117 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 112 insertions(+), 5 deletions(-)
