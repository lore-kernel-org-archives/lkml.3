Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaG1TcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:32:00 -0400
Received: from mail.anarazel.de ([217.115.131.40]:42231 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaG1Tb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:31:56 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2014 15:31:56 EDT
Date: Mon, 28 Jul 2014 21:23:26 +0200
From: Andres Freund <andres@anarazel.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 22/27] perf tools: Enable --children option by default
Message-ID: <20140728192326.GS17793@alap3.anarazel.de>
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
 <1401335910-16832-23-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401335910-16832-23-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2014-05-29 12:58:25 +0900, Namhyung Kim wrote:
> Now perf top and perf report will show children column by default if
> it has callchain information.
> 
> Requested-by: Ingo Molnar <mingo@kernel.org>
> Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
> Tested-by: Arun Sharma <asharma@fb.com>
> Acked-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Stupid question: Why? This breaks user's usage pattern in a rather
significant way because the new output is pretty much entirely useless
in many cases, especially for userland programs. I think the new option
is great, but why is it suddenly the default?

Greetings,

Andres Freund
