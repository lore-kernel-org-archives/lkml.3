Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbaDHI0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:26:47 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54805 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbaDHI0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:26:44 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        peterz@infradead.org, eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 10/15 V3] perf, c2c: Display cacheline HITM analysis to stdout
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-11-git-send-email-dzickus@redhat.com>
Date: Tue, 08 Apr 2014 17:26:43 +0900
In-Reply-To: <1395689826-215033-11-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:37:01 -0400")
Message-ID: <8738how7jw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (coalesce_level > MAX_LVL)
> +		printf("DON: bad coalesce level %d\n", coalesce_level);

Please use pr_warning() with the "DON" prefix removed :)

Thanks,
Namhyung
