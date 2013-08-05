Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3HEJII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:08:08 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47897 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab3HEJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:08:06 -0400
X-AuditID: 9c930179-b7c53ae000000457-67-51ff6b751909
From: Namhyung Kim <namhyung@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk executable
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
	<20130805081641.GA24808@gmail.com>
	<20130805082320.GA9562@infradead.org>
Date: Mon, 05 Aug 2013 18:08:04 +0900
In-Reply-To: <20130805082320.GA9562@infradead.org> (Christoph Hellwig's
	message of "Mon, 5 Aug 2013 01:23:20 -0700")
Message-ID: <87fvuozerv.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 5 Aug 2013 01:23:20 -0700, Christoph Hellwig wrote:
> On Mon, Aug 05, 2013 at 10:16:41AM +0200, Ingo Molnar wrote:
>> If you want fewer dependencies then build with 'make NO_GTK=1'.
>
> Doesn't help the distros.  Installing perf and pulling all the graphics
> libraries in is highly annoying, especially in size constrained VM or
> Cloud images.  Having a separate binary or at least an ldopen()able
> plugin that can go into a separate package is highly desirable.

I wrote a patch series [1] separating gtk code to a dso and use it with
libdl last year.  But I didn't get much feedback probably due to the
mistake of not installing the dso to a proper place.  It'd be great if
you guys take a look at it and give some comments.

Thanks,
Namhyung


[1] https://lkml.org/lkml/2012/11/14/510
