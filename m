Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaBUKGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:06:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbaBUKGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 05:06:38 -0500
Date: Fri, 21 Feb 2014 11:06:30 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: tj@kernel.org, oleg@redhat.com, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/Processor: Rework processor throttling with
 work_on_cpu()
Message-ID: <20140221100630.GA1121@krava.brq.redhat.com>
References: <20140220151721.GB32719@redhat.com>
 <1392960945-30741-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392960945-30741-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 01:35:45PM +0800, Lan Tianyu wrote:
> acpi_processor_set_throttling() uses set_cpus_allowed_ptr() to make
> sure struct acpi_processor->acpi_processor_set_throttling() callback
> run on associated cpu. But the function maybe called in a worker which
> has been bound to a cpu. The patch is to replace set_cpus_allowed_ptr()
> with work_on_cpu().

testing the new patch.. so far so good ;-)

jirka
