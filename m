Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3EUKAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:00:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33149 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3EUKAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:00:35 -0400
Message-ID: <519B45C3.8050700@arm.com>
Date: Tue, 21 May 2013 11:00:35 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Landley <rob@landley.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 0/2] PM / OPP: updates to enable sharing OPPs info
References: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
In-Reply-To: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 21 May 2013 10:00:31.0828 (UTC) FILETIME=[07A5A140:01CE560A]
X-MC-Unique: 113052111003218201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob, Grant,

On 01/05/13 12:11, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> These are couple of updates to existing PM/OPP library to support
> sharing of OPPs between different device nodes.
> 
> Currently all the cpu nodes are parsed until the OPPs are found. This
> is essential to support cpuhotplug without having to replicate OPP
> information in all the cpu nodes.
> 
> However in systems with multiple cpu power domain, its better to have
> OPP entry for each cpu. To avoid replication, phandle can be specified
> to the node which contains the full OPP information.
> 
Is proposed option of phandle for OPP acceptable to avoid replication ?
Any suggestions to proceed on this ? This is needed to support CPU
hotplug on big LITTLE system where current methods like parsing all the
nodes or just CPU0 node will not work.

Regards,
Sudeep

