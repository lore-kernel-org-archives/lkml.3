Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbaLJPKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:10:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423AbaLJPKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:10:17 -0500
Date: Wed, 10 Dec 2014 13:10:07 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH] perf kvm stat live: mark events as (x86 only) in help
 output
Message-ID: <20141210151007.GB3878@redhat.com>
References: <1418218090-20718-1-git-send-email-borntraeger@de.ibm.com>
 <54885139.5090901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54885139.5090901@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 10, 2014 at 06:57:13AM -0700, David Ahern escreveu:
> On 12/10/14 6:28 AM, Christian Borntraeger wrote:
> >diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> >  		OPT_STRING(0, "event", &kvm->report_event, "report event",
> >-			"event for reporting: vmexit, mmio, ioport"),
> >+			"event for reporting: "
> >+			"vmexit, mmio (x86 only), ioport (x86 only)"),
> 
> Acked-by: David Ahern <dsahern@gmail.com>

Thanks, applied to my local perf/core branch.

- Arnaldo
