Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaLREwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 23:52:38 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:42267 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaLREwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 23:52:37 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 18 Dec 2014 13:52:54 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, acme@redhat.com,
        dsahern@gmail.com, dzickus@redhat.com, rfowles@redhat.com,
        jmario@redhat.com
Subject: Re: [PATCH v3] perf mem: enable sampling loads and stores
 simultaneously
Message-ID: <20141218045254.GC20215@sejong>
References: <20141217152355.GA10053@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141217152355.GA10053@thinkpad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Wed, Dec 17, 2014 at 04:23:55PM +0100, Stephane Eranian wrote:
> 
> This patch modifies perf mem to default to sampling loads
> and stores simultaneously. It could only do one or the other
> before yet there was no hardware restriction preventing
> simultaneous collection. With this patch, one run is sufficient
> to collect both.
> 
> It is still possible to sample only loads or stores by using the
> -t option:
>  $ perf mem -t load rec
>  $ perf mem -t load rep
> Or
>  $ perf mem -t store rec
>  $ perf mem -t store rep
> 
> The perf report TUI will show one event at a time. The store
> output will contain a Weight column which will be empty.
> 
> In V2, we updated the man pages to reflect the change and
> also simplify the initialization of the argv vector passed
> to the cmd_*() functions as per LKML feedback.
> 
> In V3, we fixed typos in the changelog.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
