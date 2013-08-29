Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3H2Rzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:55:45 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:16076 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3H2Rzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:55:43 -0400
Date: Thu, 29 Aug 2013 19:55:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Yang, Fei" <fei.yang@intel.com>
Cc: Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: Re: Can anyone suggest a better fix? Not sure if I understand the
	problem, but the patch fixed it
Message-ID: <20130829175542.GB23620@merkur.ravnborg.org>
References: <02E7334B1630744CBDC55DA85862258348E431C1@ORSMSX102.amr.corp.intel.com> <20130826201035.GA21141@merkur.ravnborg.org> <02E7334B1630744CBDC55DA85862258348E458D8@ORSMSX102.amr.corp.intel.com> <521E1232.6010501@suse.cz> <02E7334B1630744CBDC55DA85862258348E4792D@ORSMSX102.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02E7334B1630744CBDC55DA85862258348E4792D@ORSMSX102.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Nothing fancy except the kernel build is triggered by Android build system. And the driver is being built into the kernel with obj-(CONFIG_MY_DRIVER) += my-driver.o, so it's not even a loadable module.
> I thought fixdep is about finding module dependency, and it isn't needed for built-in drivers. Please correct me if I'm wrong. I want to understand if the .d file had never been generated or had been generated but deleted by the time fixdep tries to open it.
> 
Please teach yourself to punch new-line now and then.

	Sam
