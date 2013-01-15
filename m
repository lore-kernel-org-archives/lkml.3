Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012Ab3AOWyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:54:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:47524 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933996Ab3AOWyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:54:10 -0500
Date: Tue, 15 Jan 2013 14:47:18 -0800
From: Greg KH <greg@kroah.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Anton Blanchard <anton@au1.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        robert.richter@amd.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/6][v3] perf: Document the ABI of perf sysfs entries
Message-ID: <20130115224718.GC32544@kroah.com>
References: <20130110010347.GA32590@us.ibm.com>
 <20130110010703.GF32590@us.ibm.com>
 <20130115185759.GG5826@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115185759.GG5826@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 03:57:59PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 09, 2013 at 05:07:03PM -0800, Sukadev Bhattiprolu escreveu:
> > [PATCH 6/6][v3] perf: Document the ABI of perf sysfs entries
> > 
> > This patchset addes two new sets of files to sysfs:
> > 
> > 	- generic and POWER-specific perf events in /sys/devices/cpu/events/
> > 	- perf event config format in /sys/devices/cpu/format/event
> > 
> > Document the format of these files which would become part of the ABI.
> > 
> > Changelog[v3]:
> > 	[Greg KH] Include ABI documentation.
> 
> Jiri, can I have your ack on this one too?
> 
> Greg, all ok now?

No objection from me, thanks.

greg k-h
