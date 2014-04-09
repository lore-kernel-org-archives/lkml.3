Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbaDICUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:20:37 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:41650 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235AbaDICUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:20:33 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        andi.kleen@intel.com
Subject: Re: [PATCH 2/6] perf: Update mmap2 interface with protection and flag bits
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
	<1395689676-214799-3-git-send-email-dzickus@redhat.com>
	<871tx7utyv.fsf@sejong.aot.lge.com>
Date: Wed, 09 Apr 2014 11:20:31 +0900
In-Reply-To: <871tx7utyv.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Wed, 09 Apr 2014 11:17:44 +0900")
Message-ID: <87txa3tf9s.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Apr 2014 11:17:44 +0900, Namhyung Kim wrote:
> So you need to synthesize a PERF_RECORD_MMAP2 event then.  The
> mmap_event and mmap2_event shares same fields util ->pgoff only.  So
> copying to mmap.filename will overwrite other bits in mmap2.

Oops, missed patch 3/3 already does it.  Sorry for noise.

Thanks,
Namhyung
