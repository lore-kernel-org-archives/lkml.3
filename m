Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3ARToD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:44:03 -0500
Received: from mail-gh0-f179.google.com ([209.85.160.179]:35039 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3ARToB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:44:01 -0500
Date: Fri, 18 Jan 2013 16:20:32 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 6/6][v3] perf: Document the ABI of perf sysfs entries
Message-ID: <20130118192032.GB2390@ghostprotocols.net>
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
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 18, 2013 at 09:46:54AM -0800, Sukadev Bhattiprolu escreveu:
> Jiri Olsa [jolsa@redhat.com] wrote:
> | Maybe it'd worth to mention, that it does not need to be just 'event',
> | but anything from /sys/bus/event_source/devices/<dev>/format directory,
> | like
> | 
> | 		The can be multiple terms like 'event=0xNNNN' specified
> | 		and separated with comma. All available terms are located
> | 		in /sys/bus/event_source/devices/<dev>/format file.
> | 
> | Please feel free to rephrase or use proper English ;-)
> | 
> | otherwise it's ok,
> | jirka
> 
> Agree.  Thanks for the review. Here is the updated patch.

Ok, I'll wait for Jiri's final acked-by, then you can resubmit the patch
series and I'll apply it to my perf/core branch.

- Arnaldo
