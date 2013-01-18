Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3ARPMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:12:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50153 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3ARPMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:12:30 -0500
Date: Fri, 18 Jan 2013 10:12:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        konrad@kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH] fixes to ACPI subsystem which assumes cpuidle is always
 enabled.
Message-ID: <20130118151219.GI9214@phenom.dumpdata.com>
References: <1358288604-24620-1-git-send-email-konrad.wilk@oracle.com>
 <1449747.HgoeXlbhzH@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1449747.HgoeXlbhzH@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 11:49:00PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, January 15, 2013 05:23:22 PM Konrad Rzeszutek Wilk wrote:
> > Attached are two patches to the ACPI subsystem and the cpuidle drivers.
> > 
> > The fixes are to deal with the case when cpuidle_disabled returns true
> > and we try to hotplug CPUs on/off. 
> > 
> >  drivers/acpi/processor_idle.c | 3 +++
> >  drivers/idle/intel_idle.c     | 3 +--
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> Both patches applied.

Thanks!
> 
> Thanks,
> Rafael
> 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
