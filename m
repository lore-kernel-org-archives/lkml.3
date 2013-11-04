Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3KDOwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:52:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab3KDOwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:52:00 -0500
Date: Mon, 4 Nov 2013 15:51:11 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v4 2/4] perf stat: add event unit and scale support
Message-ID: <20131104145110.GA2805@krava.brq.redhat.com>
References: <1383231582-15856-1-git-send-email-eranian@google.com>
 <1383231582-15856-3-git-send-email-eranian@google.com>
 <20131101105722.GA1088@krava.brq.redhat.com>
 <CABPqkBRXPYHNmCbcGDvqSNxY_zWfUiy3S3_9SasrVw9nbNL9Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRXPYHNmCbcGDvqSNxY_zWfUiy3S3_9SasrVw9nbNL9Mg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 03:47:53PM +0100, Stephane Eranian wrote:
> Jiri,
> 
> 
> Thanks for the patch. I tested it and it works fine.
> I will merge it with my "unit and scale" and add
> your Signed-off-by. Is that okay with you?

sure, np

jirka
