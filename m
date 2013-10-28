Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3J1FJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:09:53 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44726 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3J1FJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:09:52 -0400
X-AuditID: 9c93017d-b7c97ae000000e9f-fe-526df19de4ec
From: Namhyung Kim <namhyung@kernel.org>
To: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, asharma@fb.com, fweisbec@gmail.com
Subject: Re: State of "perf: Add a new sort order: SORT_INCLUSIVE"
References: <20131025150721.GA12534@sdfg.com.ar>
Date: Mon, 28 Oct 2013 14:09:49 +0900
In-Reply-To: <20131025150721.GA12534@sdfg.com.ar> (Rodrigo Campos's message of
	"Fri, 25 Oct 2013 16:07:21 +0100")
Message-ID: <8761si9e1u.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodrigo,

On Fri, 25 Oct 2013 16:07:21 +0100, Rodrigo Campos wrote:
> Hi Namhyung,
>
> Frederic Weisbecker and Arnaldo Carvalho de Melo told me on IRC that you were
> working to forward-port a patch that adds a new sort order to perf report,
> SORT_INCLUSIVE.
>
> That will be useful for me and I was wondering if you are still working on that
> or if there is a newer version than v6:
>
> 	http://thread.gmane.org/gmane.linux.kernel.perf.user/882
>
>
> Maybe you have a newer version of it not sent to the list ? Or do you plan to
> work on it anytime soon ?
>
> If there is any branch to test, please let me know :)

Yes I have a patch series for that.  But it's not a new sort order but a
new command line option --culumate.  I don't think it should be a new
sort order since it affects only how it counts period value on each
sample not how samples are sorted/grouped.

It's about a year since I sent this series to list.  I'll work on it and
send it to the list soon.  But before that I have to re-read what's the
Frederic's concern - IIRC it's about consolidating code in perf report
that does similar things on branch stack.

Frederic, can you remember what was the problem?

Anyway, You can find the series and discussion on the link below:

  https://lkml.org/lkml/2012/9/13/81

Thanks,
Namhyung
