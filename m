Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaIQQFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:05:14 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56297 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaIQQFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:05:12 -0400
Date: Wed, 17 Sep 2014 09:05:08 -0700
From: Graeme Gregory <graeme.gregory@linaro.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
Message-ID: <20140917160508.GA2464@xora-yoga-13>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-19-git-send-email-hanjun.guo@linaro.org>
 <20140917014410.GC31214@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917014410.GC31214@srcf.ucam.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 02:44:10AM +0100, Matthew Garrett wrote:
> On Fri, Sep 12, 2014 at 10:00:16PM +0800, Hanjun Guo wrote:
> 
> > +Common _DSD bindings should be submitted to ASWG to be included in the
> > +document :-
> > +
> > +http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
> 
> How are individuals/companies who aren't UEFI members supposed to do 
> this? Aren't there IP issues involved in taking submissions from 
> non-members?
> 

This section needs to be changed anyway, it comes out of a
misunderstanding I had of the _DSD spec.

It sounds like from the discussions in other threads that ARM64 should
be following x86 and re-using DT bindings here. In which case there is
not need to submit things to UEFI organisation.

What I got a little lost in has there been a formal decision about DT
bindings in _DSD?

Graeme

