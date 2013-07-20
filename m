Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3GTMWg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 08:22:36 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:36407 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab3GTMWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 08:22:21 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 0/2] PM / OPP: updates to enable sharing OPPs info
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Cc: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Landley <rob@landley.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
In-Reply-To: <519B45C3.8050700@arm.com>
References: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <519B45C3.8050700@arm.com>
Date: Sat, 20 Jul 2013 06:09:43 +0100
Message-Id: <20130720050943.5EB853E169C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 May 2013 11:00:35 +0100, Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com> wrote:
> Hi Rob, Grant,
> 
> On 01/05/13 12:11, Sudeep KarkadaNagesha wrote:
> > From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> > 
> > These are couple of updates to existing PM/OPP library to support
> > sharing of OPPs between different device nodes.
> > 
> > Currently all the cpu nodes are parsed until the OPPs are found. This
> > is essential to support cpuhotplug without having to replicate OPP
> > information in all the cpu nodes.
> > 
> > However in systems with multiple cpu power domain, its better to have
> > OPP entry for each cpu. To avoid replication, phandle can be specified
> > to the node which contains the full OPP information.
> > 
> Is proposed option of phandle for OPP acceptable to avoid replication ?
> Any suggestions to proceed on this ? This is needed to support CPU
> hotplug on big LITTLE system where current methods like parsing all the
> nodes or just CPU0 node will not work.

Looks fine to me.

g.

