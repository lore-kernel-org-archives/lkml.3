Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3EQIzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:55:47 -0400
Received: from sauhun.de ([89.238.76.85]:32798 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab3EQIzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:55:45 -0400
Date: Fri, 17 May 2013 10:56:57 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH v7] i2c-designware: make SDA hold time configurable
Message-ID: <20130517085653.GG17056@katana>
References: <20130327084158.GB11010@ab42.lan>
 <1364373760-12469-1-git-send-email-christian.ruppert@abilis.com>
 <20130514110745.GA10906@intel.com>
 <20130517082925.GB17056@katana>
 <20130517084437.GD11878@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517084437.GD11878@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > New bindings are complicated. I need to check if there is an
> > existing/similar one, check if it is generic enough for drivers still to
> > come, etc. I didn't have the time to do this for 3.10, so it is
> > 3.11 material.
> 
> OK, thanks. I just wanted to be sure this patch wasn't forgotten as it is
> useful for Haswell/Lynxpoint as well.

i2c list is monitored by patchwork which is rigorously not forgetting ;)

