Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaG2Ndq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:33:46 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:61025 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaG2Ndo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:33:44 -0400
Date: Tue, 29 Jul 2014 09:33:27 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        javi.merino@arm.com, rui.zhang@intel.com, rostedt@goodmis.org
Subject: Re: [PATCH 0/3] Add trace to thermal framework
Message-ID: <20140729133327.GA3336@developer>
References: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
 <1406631050-14975-1-git-send-email-punit.agrawal@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406631050-14975-1-git-send-email-punit.agrawal@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 11:50:47AM +0100, Punit Agrawal wrote:
> Hi linux-pm,
> 
> This is the second posting of the patches to add trace to the thermal
> framework.
> 
> The linux thermal framework doesn't have any support for tracing. This
> makes it hard to run workloads and observe the thermal behaviour of
> the system without actively polling files in sysfs or enabling debug
> builds.
> 
> This patch set introduces trace events in the framework to allow
> observing the behaviour of the different components in the
> framework. The events added trace temperature changes, trip points and
> cooling device state changes.
> 
> changes since rfc:
> * Fixed an issue where incorrect trip point was traced when using fair
> share
> * Trace the numeric value of trip_type instead of using __print_symbolic

Pulled the series.

Thanks.

> 
> Punit Agrawal (3):
>   thermal: trace: Trace temperature changes
>   thermal: trace: Trace when a cooling device's state is updated
>   thermal: trace: Trace when temperature is above a trip point
> 
>  drivers/thermal/fair_share.c   |   12 ++++++
>  drivers/thermal/step_wise.c    |    5 ++-
>  drivers/thermal/thermal_core.c |    7 ++++
>  include/trace/events/thermal.h |   87 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 110 insertions(+), 1 deletion(-)
>  create mode 100644 include/trace/events/thermal.h
> 
> -- 
> 1.7.10.4
> 
