Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaE3HPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:15:44 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:61270 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaE3HPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:15:43 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: jolsa@redhat.com, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, eranian@google.com,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/7 V4] perf: Enable mmap2 and add dcacheline sorting
References: <1401208087-181977-1-git-send-email-dzickus@redhat.com>
Date: Fri, 30 May 2014 16:15:40 +0900
In-Reply-To: <1401208087-181977-1-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Tue, 27 May 2014 12:28:00 -0400")
Message-ID: <87r43benz7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 12:28:00 -0400, Don Zickus wrote:
> These patches enable mmap2 support in the kernel and perf to
> allow support for data cacheline sorting.
>
> Note: I haven't been able to reproduce Jiri's perf hang yet, so I don't
> have a patch for that particular problem yet.

I have no idea what the hang case is, but from a quick look, the code
for the tooling part (beside few nitpicks) looks good to me.

Thanks,
Namhyung
