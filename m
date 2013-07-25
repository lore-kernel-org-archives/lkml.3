Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3GYN12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:27:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24563 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab3GYN1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:27:24 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Mk8slKPNyHgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3SVVvi5Q3acA:10 a=P5kU7FD9ZMq50Ig7QFMA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374758841.3356.174.camel@gandalf.local.home>
Subject: Re: [PATCH 0/4] iommu: Add event tracing feature to iommu
From: Steven Rostedt <rostedt@goodmis.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, fweisbec@gmail.com, mingo@redhat.com,
        tony@atomide.com, ohad@wizery.com, andreas.herrmann@calxeda.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Date: Thu, 25 Jul 2013 09:27:21 -0400
In-Reply-To: <cover.1374711464.git.shuah.kh@samsung.com>
References: <cover.1374711464.git.shuah.kh@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 07:15 -0600, Shuah Khan wrote:

> Shuah Khan (4):
>   iommu: Add event tracing feature to iommu - Add iommu trace events
>   iommu: Add event tracing feature to iommu - export trace events
>   iommu: Add event tracing feature to iommu - amd_iommu driver trace
>     events
>   iommu: Add event tracing feature to iommu - iommu driver trace events
> 
>  drivers/iommu/Makefile       |    1 +
>  drivers/iommu/amd_iommu.c    |   19 +++++
>  drivers/iommu/iommu-traces.c |   27 +++++++
>  drivers/iommu/iommu.c        |   17 ++++-
>  include/trace/events/iommu.h |  174 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 237 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/iommu/iommu-traces.c
>  create mode 100644 include/trace/events/iommu.h

I don't know what the maintainer thinks, but usually new tracepoints
like this are done as one patch. Not four.

-- Steve



