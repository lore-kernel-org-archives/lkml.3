Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946067Ab3BHIWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:22:44 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60761 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759790Ab3BHIWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:22:43 -0500
X-AuditID: 9c930179-b7c24ae00000119c-5c-5114b5d239a5
From: Namhyung Kim <namhyung@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] stop_machine: dequeue work before signal completion
References: <CAJd=RBBvE-5f1UyJGu32EHGVCXe6rVYY0010SKa56j7OvtPG7g@mail.gmail.com>
Date: Fri, 08 Feb 2013 17:22:42 +0900
In-Reply-To: <CAJd=RBBvE-5f1UyJGu32EHGVCXe6rVYY0010SKa56j7OvtPG7g@mail.gmail.com>
	(Hillf Danton's message of "Fri, 8 Feb 2013 11:42:43 +0800")
Message-ID: <87pq0bqkod.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013 11:42:43 +0800, Hillf Danton wrote:
> As checked with BUG_ON in the case of CPU_UP_PREPARE, we have to dequeue
> work first for further actions, then stopper reaches sane and clear state.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
