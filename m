Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbaDICcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:32:48 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:49222 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbaDICcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:32:47 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        andi.kleen@intel.com
Subject: Re: [PATCH 3/6] Revert "perf: Disable PERF_RECORD_MMAP2 support"
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
	<1395689676-214799-4-git-send-email-dzickus@redhat.com>
Date: Wed, 09 Apr 2014 11:32:40 +0900
In-Reply-To: <1395689676-214799-4-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:34:33 -0400")
Message-ID: <87ppkrtepj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 15:34:33 -0400, Don Zickus wrote:
> This reverts commit 3090ffb5a2515990182f3f55b0688a7817325488.

It seems if you exchange the order of patch 2 and 3 it'd be less
confusing  ;-p

Thanks,
Namhyung
