Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab3BFElq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:41:46 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43125 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3BFElp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:41:45 -0500
X-AuditID: 9c930179-b7c24ae00000119c-1c-5111df07ae76
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 01/11] perf ui/hist: Add support to display whole group data for raw columns
References: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
	<1359981185-16819-2-git-send-email-jolsa@redhat.com>
Date: Wed, 06 Feb 2013 13:41:42 +0900
In-Reply-To: <1359981185-16819-2-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Mon, 4 Feb 2013 13:32:55 +0100")
Message-ID: <87sj5arr3t.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon,  4 Feb 2013 13:32:55 +0100, Jiri Olsa wrote:
> Currently we don't display group members' values for raw
> columns like 'Samples' and 'Period' when in group report
> mode.

Oops, it was lost during the rework.  Thanks for fixing this.

Thanks,
Namhyung
