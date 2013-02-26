Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3BZFqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:46:20 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56910 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3BZFqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:46:17 -0500
X-AuditID: 9c930179-b7b61ae000004061-46-512c4c272b8e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, peterz@infradead.org, mingo@elte.hu
Subject: Re: [PATCH] perf report: fix handling of memory sampling sort orders
References: <20130222142838.GA2847@quad>
	<20130222184322.GF16956@infradead.org>
Date: Tue, 26 Feb 2013 14:46:14 +0900
In-Reply-To: <20130222184322.GF16956@infradead.org> (Arnaldo Carvalho de
	Melo's message of "Fri, 22 Feb 2013 15:43:22 -0300")
Message-ID: <8738wjtyop.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 22 Feb 2013 15:43:22 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Feb 22, 2013 at 03:28:38PM +0100, Stephane Eranian escreveu:
>> 
>> When the memory sampling sort orders were used on perf.data
>> files without memory sampling data, it would crash perf. This
>> patch fixes this by  handling the lack of memory information
>> gracefully, printing N/A and formatting columns correctly
>> whenever necessary.

It'd be great if we could detect the perf.data contains memory sampling
data and then warn user about it and exit like I did for branch
sampling.  What do you think?

Thanks,
Namhyung
