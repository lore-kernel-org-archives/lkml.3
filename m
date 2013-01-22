Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3AVRLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:11:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab3AVRLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:11:09 -0500
Date: Tue, 22 Jan 2013 18:10:13 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 6/6][v3] perf: Document the ABI of perf sysfs entries
Message-ID: <20130122171013.GM1037@krava.brq.redhat.com>
References: <20130110010347.GA32590@us.ibm.com>
 <20130110010703.GF32590@us.ibm.com>
 <20130115185759.GG5826@ghostprotocols.net>
 <20130116113013.GA1042@krava.brq.redhat.com>
 <20130116185815.GA3351@us.ibm.com>
 <20130117141145.GA3817@krava.brq.redhat.com>
 <20130118174654.GA12575@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118174654.GA12575@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 09:46:54AM -0800, Sukadev Bhattiprolu wrote:
> Jiri Olsa [jolsa@redhat.com] wrote:

SNIP

> +
> +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +		Linux Powerpc mailing list <linuxppc-dev@ozlabs.org>
> +
> +Description:	POWER-systems specific performance monitoring events
> +
> +		A collection of performance monitoring events that may be
> +		supported by the POWER CPU. These events can be monitored
> +		using the 'perf(1)' tool.
> +
> +		These events may not be supported by other CPUs.
> +
> +		The contents of each file would look like:
> +
> +			event=0xNNNN
> +
> +		where 'N' is a hex digit and the number '0xNNNN' shows the
> +		"raw code" for the perf event identified by the file's
> +		"basename".
> +
> +		Further, multiple terms like 'event=0xNNNN' can be specified
> +		and separated with comma. All available terms are defined in
> +		the /sys/bus/event_source/devices/<dev>/format file.

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
