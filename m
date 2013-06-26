Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab3FZBod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:44:33 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53809 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3FZBoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:44:32 -0400
X-AuditID: 9c930179-b7cafae000004567-3b-51ca477ee53c
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/15] perf tools: validate perf event header size
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
	<1372079772-20803-10-git-send-email-adrian.hunter@intel.com>
Date: Wed, 26 Jun 2013 10:44:30 +0900
In-Reply-To: <1372079772-20803-10-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Mon, 24 Jun 2013 16:16:06 +0300")
Message-ID: <87wqph1w8x.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Mon, 24 Jun 2013 16:16:06 +0300, Adrian Hunter wrote:
> 'size' includes the header so must be at least
> 'sizeof(struct perf_event_header)'.  Error out
> immediately if that is not the case.  Also

Just out of curiosity.

Do you have an experience it really matters?  AFAICS such an invalid
sample should be detected during sample processing.

Thanks,
Namhyung
