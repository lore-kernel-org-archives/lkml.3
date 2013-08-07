Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab3HGT7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:59:41 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:57363 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab3HGT7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:59:40 -0400
Date: Wed, 7 Aug 2013 16:05:57 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Mark Rutland <mark.rutland@arm.com>
cc: Will Deacon <will.deacon@arm.com>, Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "trinity@vger.kernel.org" <trinity@vger.kernel.org>
Subject: Re: perf,arm -- oops in validate_event
In-Reply-To: <20130807135437.GD28558@e106331-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.10.1308071605060.14098@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308051622270.28589@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1308051711080.31327@vincent-weaver-1.um.maine.edu> <20130806111932.GA25383@e106331-lin.cambridge.arm.com> <20130806115921.GA14798@mudshark.cambridge.arm.com>
 <20130806130815.GC25383@e106331-lin.cambridge.arm.com> <20130807130027.GA16474@mudshark.cambridge.arm.com> <20130807135437.GD28558@e106331-lin.cambridge.arm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013, Mark Rutland wrote:

> On Wed, Aug 07, 2013 at 02:00:27PM +0100, Will Deacon wrote:
> > On Tue, Aug 06, 2013 at 02:08:15PM +0100, Mark Rutland wrote:
> > > On Tue, Aug 06, 2013 at 12:59:21PM +0100, Will Deacon wrote:
> > Ok, so the following quick hack below should solve the issue (can you confirm
> > it please, since I don't have access to any hardware atm?)
> 
> It works for me when running Vince's test case.
> 
> Tested-by: Mark Rutland <mark.rutland@arm.com>

I've also tested it and the fix works for the various test cases I've 
constructed for this issue.

Tested-by: Vince Weaver <vincent.weaver@maine.edu>

