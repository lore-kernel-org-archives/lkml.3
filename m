Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762022Ab3IDGI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:08:59 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44215 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761946Ab3IDGI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:08:57 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-07-5226ce77490d
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
References: <20130903072944.4793.93584.stgit@hemant-fedora>
Date: Wed, 04 Sep 2013 15:08:55 +0900
In-Reply-To: <20130903072944.4793.93584.stgit@hemant-fedora> (Hemant Kumar
	Shaw's message of "Tue, 03 Sep 2013 13:06:40 +0530")
Message-ID: <87mwntt8y0.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemant,

On Tue, 03 Sep 2013 13:06:40 +0530, Hemant Kumar Shaw wrote:
> This series adds support to perf to list and probe into the SDT markers.
> The first patch implements listing of all the SDT markers present in
> the ELFs (executables or libraries). The SDT markers are present in the
> .note.stapsdt section of the elf. That section can be traversed to list
> all the markers. Recognition of markers follows the SystemTap approach.
>
> The second patch will allow perf to probe into these markers. This is
> done by writing the marker name and its offset into the
> uprobe_events file in the tracing directory.
> Then, perf tools can be used to analyze perf.data file.

First, thanks for your work!

In fact, I was working on the same topic of support SDT markers.  But I
started it by adding support for accessing arguments in uprobes [1].
The patchset is floating around the list for now but I hope it'll get
merged soon.  I guess you want to have it too :).

Anyway, it'd great if you add me to CC next time.

Thanks,
Namhyung


[1] http://thread.gmane.org/gmane.linux.kernel/1555044
