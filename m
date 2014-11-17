Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaKQGcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 01:32:11 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59217 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaKQGcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 01:32:10 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/8] perf, tools: Add --branch-history option to report
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
	<1411774636-6870-3-git-send-email-andi@firstfloor.org>
	<87mw8ogaj8.fsf@sejong.aot.lge.com>
	<20141112000505.GM12538@two.firstfloor.org>
Date: Mon, 17 Nov 2014 15:31:57 +0900
In-Reply-To: <20141112000505.GM12538@two.firstfloor.org> (Andi Kleen's message
	of "Wed, 12 Nov 2014 01:05:05 +0100")
Message-ID: <87389itk0y.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014 01:05:05 +0100, Andi Kleen wrote:
>> And please also add a new CCKEY_SRCLINE if you print srcline with the
>> callchains so that users can give "-g srcline" if they want (regardless
>> of the branch history feature).
>
> That would be largely identical to CCKEY_ADDRESS 
> except for the case of two calls to the same function from
> the same line. Probably not worth adding?

For sorting, yes, it'd be almost identical.  But what I'm saying is for
printing - IOW print callchain entries with symbol and srcline (for
normal perf report too).

Anyway, I think it'd be a separate patch(set).

Thanks,
Namhyung
