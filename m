Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3AVN6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:58:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3AVN6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:58:03 -0500
Date: Tue, 22 Jan 2013 14:57:26 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: acme@ghostprotocols.net, Anton Blanchard <anton@au1.ibm.com>,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] perf: Fix compile warnings in tests/attr.c
Message-ID: <20130122135726.GD1037@krava.brq.redhat.com>
References: <20130119013052.GA24693@us.ibm.com>
 <20130121135906.GD1995@krava.brq.redhat.com>
 <20130121213823.GA4774@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121213823.GA4774@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 01:38:23PM -0800, Sukadev Bhattiprolu wrote:
> Jiri Olsa [jolsa@redhat.com] wrote:
> | On Fri, Jan 18, 2013 at 05:30:52PM -0800, Sukadev Bhattiprolu wrote:

SNIP

> __u64 is 'unsigned long long' on x86 and PRIu64 is 'llu' which is fine.
> 
> __u64 is 'unsigned long' on Power and PRIu64 is 'lu' which is again fine.
> 
> But __u64 is 'unsigned long long' on x86_64, but PRIu64 is '%lu' bc __WORDSIZE
> is 64.
> 
> On x86_64, shouldn't __u64, be defined as 'unsigned long' rather than
> 'unsigned long long' - ie include 'int-l64.h' rather than 'int-ll64.h' ?

hum, not sure ;-) will try to find some time to look on that

> 
> BTW, does 'perf' with my patch compile, (with warnings) for you on x86_64
> with 'WERROR=0 make' ?

this one passes with warnings

jirka
