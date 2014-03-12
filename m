Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbaCLSjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:39:10 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:52595 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaCLSjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:39:08 -0400
Date: Wed, 12 Mar 2014 15:39:01 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Cc: Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Provide additional sample information to Python scripts
Message-ID: <20140312183901.GB19451@ghostprotocols.net>
References: <53031D2C.2050009@tu-dresden.de>
 <20140307141857.GA3153@ghostprotocols.net>
 <53207D3E.4010402@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53207D3E.4010402@tu-dresden.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 12, 2014 at 04:29:02PM +0100, Thomas Ilsche escreveu:
> On 2014-03-07 15:18, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Feb 18, 2014 at 09:43:24AM +0100, Joseph Schuchart escreveu:
> >> Good morning,
> >>
> >> We have developed a patch for the perf Python scripting interface to
> >> provide additional information about the pid, tid, and cpu of generic
> >> events as well as information about the call-stack and resolved symbol
> >> names. This provides scripts with a greater level of detail. The
> >> mentioned information is already available to the scripting engine and
> >> just has to be handed down. This is done by the attached patch. The
> >> patch is based on Linux-3.13.3.
> >>
> >> Please let me know if you have any questions on this.
> > 
> > Can you please resend, against the perf/core branch in
> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git, and as an
> > attachement or making sure that the patch is not mangled?
> 
> Joseph and I are working on this but due to vacation we expect to send
> you the patch with some improvements in the beginning of April. Please
> let us know in case there is some deadline.

Take your time, send it when you have addressed the issues reported.

Please, just before submitting, check that it still applies to the
branch pointed out above.

- Arnaldo
