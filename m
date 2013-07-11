Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab3GKEgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 00:36:51 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:49773 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3GKEgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 00:36:49 -0400
Date: Thu, 11 Jul 2013 00:42:31 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Ingo Molnar <mingo@kernel.org>
cc: Michael Ellerman <michael@ellerman.id.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Vince Weaver <vince@deater.net>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com,
        Stephane Eranian <eranian@google.com>, sukadev@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for
 perf
In-Reply-To: <20130710083435.GA24070@gmail.com>
Message-ID: <alpine.DEB.2.10.1307110039560.26051@vincent-weaver-1.um.maine.edu>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com> <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com> <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy> <20130704125218.GA21134@concordia>
 <20130704125700.GM18898@dyad.programming.kicks-ass.net> <20130709012952.GA7185@concordia> <alpine.DEB.2.10.1307082204550.26280@vincent-weaver-1.um.maine.edu> <20130709081434.GI25631@dyad.programming.kicks-ass.net> <20130710030926.GD7491@concordia>
 <20130710083435.GA24070@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013, Ingo Molnar wrote:

> Exactly - PMUs enumerated in /sys should be self-identifying, it's a 
> hardware topology after all ...
> 
> Anytime userspace is forced to look into /proc, or into weird places in 
> /sys it's a FAIL really.

well on x86 you have to look at /proc/cpuinfo to get the 
vendor/family/model number.  Should we add some specifier under sys?
It's probably too late though as all userspace event libs will have
to look at /proc/cpuinfo anyway to be backwards compatible.

Vince
