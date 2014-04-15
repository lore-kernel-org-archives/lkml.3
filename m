Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaDOTgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:36:35 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:46442 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaDOTgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:36:32 -0400
Date: Tue, 15 Apr 2014 15:39:47 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Vince Weaver <vincent.weaver@maine.edu>, Christoph Lameter <cl@linux.com>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
In-Reply-To: <20140415193116.GU24070@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.10.1404151539110.15528@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404150940250.14106@vincent-weaver-1.um.maine.edu> <534D4A59.6080401@suse.cz> <alpine.DEB.2.10.1404151146530.26562@gentwo.org> <534D6510.3070509@suse.cz> <alpine.DEB.2.10.1404151221360.26992@gentwo.org> <20140415182653.GR24070@n2100.arm.linux.org.uk>
 <alpine.DEB.2.10.1404151507290.15528@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404151530050.15528@vincent-weaver-1.um.maine.edu> <20140415193116.GU24070@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Russell King - ARM Linux wrote:
> 
> Hmm, any ideas what HAVE_INST_PATH is set to?  It would be good to have
> the complete picture on this bug. :)

In debian/ruleset/misc/version_vars.mk

HAVE_INST_PATH  =$(call doit,grep -E '\(INSTALL_PATH\)' Makefile 2>/dev/null )


Vince
